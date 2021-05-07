using Clp
using JuMP
using Gurobi

include("Assignment_1_mod_loop.jl")

# model - The model
# x - Hektar / crop (var)
# B - Liter biofuel (var)
# M - Methanol
# P - Petrol
# y - Unrefined biodiesel
# VegOil - Vegetable oil
starVal = 1600
jumpVal = 100
endVal = 2600
i = starVal
iterations = round((endVal-starVal)/jumpVal + 1)

zA = zeros(1,convert(Int64, iterations))

B5A = zeros(1,convert(UInt8, iterations))
B30A = zeros(1,convert(UInt8, iterations))
B100A = zeros(1,convert(UInt8, iterations))

MethanolA = zeros(1,convert(UInt8, iterations))
PetrolDiselA = zeros(1,convert(UInt8, iterations))
BiodiselA = zeros(1,convert(UInt8, iterations))
VegOilA = zeros(1,convert(UInt8, iterations))
WaterInUseA = zeros(1,convert(UInt8, iterations))
AreaInUseA = zeros(1,convert(UInt8, iterations))
SoybeansA = zeros(1,convert(UInt8, iterations))
SunflowerA = zeros(1,convert(UInt8, iterations))
CottonA = zeros(1,convert(UInt8, iterations))
j = 1
while true
    global model, x, B, Methanol, petrol, unrefBiodiesel, VegOil = build_zMax_model(i)
    set_optimizer(model, Gurobi.Optimizer)
    optimize!(model)

    global zA[j] = objective_value(model)

    global B5A[j] = value.(B.data[1])
    global B30A[j] = value.(B.data[2])
    global B100A[j] = value.(B.data[3])

    global MethanolA[j] = value.(Methanol)
    global PetrolDiselA[j] = value.(petrol)
    global BiodiselA[j] = value.(unrefBiodiesel)
    global VegOilA[j] = value.(VegOil)
    global WaterInUseA[j] = value.(x.data[1])*crop_table[1,2]+value.(x.data[2])*crop_table[2,2]+value.(x.data[3])*crop_table[3,2]
    global AreaInUseA[j] = value.(x.data[1])+value.(x.data[2])+value.(x.data[3])

    global SoybeansA[j] = value.(x.data[1])
    global SunflowerA[j] = value.(x.data[2])
    global CottonA[j] = value.(x.data[3])

    println("B[1] (B5) = \t", value.(B.data[2]))

    #The way to break the loop.
    if abs(endVal-i) <= 10^(-8)
        break
    end


    global j = j + 1
    global i =  i + jumpVal
end

println("\n")
println("-------------------------------------------\n")
println("Z (Obj) = \t", round.(zA))

println("\n")
println("B[1] (B5) = \t", round.(B5A))
println("B[2] (B30) = \t", round.(B30A))
println("B[3] (B100) = \t", round.(B100A))

println("\n")
println("Methanol = \t", round.(MethanolA))
println("Petrol disel = \t", round.(PetrolDiselA))
println("Biodisel = \t", round.(BiodiselA))
println("VegOil = \t", round.(VegOilA))
println("Water in use = \t", round.(WaterInUseA))
println("Area in use = \t", round.(AreaInUseA))

println("\n")
println("X[1] (Soybeans) = \t", round.(SoybeansA))
println("X[2] (Sunflower seeds) = ", round.(SunflowerA))
println("X[3] (Cotton seeds) = \t", round.(CottonA))
println("-------------------------------------------\n")

printVar = B5A
    println("\n-----------------")
    for i = 1:size(printVar)[2]
        println(convert(Int64, round(printVar[i])))
    end
    println("-----------------\n")
