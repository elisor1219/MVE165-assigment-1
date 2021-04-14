using Clp
using JuMP
using Gurobi

debuging = false

include("Assignment_1_mod.jl")

# model - The model
# x - Hektar / crop (var)
# B - Liter biofuel (var)
# M - Methanol
# P - Petrol
# y - Unrefined biodiesel
# VegOil - Vegetable oil
starVal = 1600
jumpVal = 100
endVal = 2500
i = starVal
iterations = (endVal-starVal)/jumpVal + 1

zA = zeros(1,convert(UInt8, iterations))

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
while i <= endVal
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

    global j = j + 1
    global i =  i + jumpVal
end

println("\n")
println("Z (Obj) = \t", zA)

println("\n")
println("B[1] (B5) = \t", B5A)
println("B[2] (B30) = \t", B30A)
println("B[3] (B100) = \t", B100A)

println("\n")
println("Methanol = \t", MethanolA)
println("Petrol disel = \t", PetrolDiselA)
println("Biodisel = \t", BiodiselA)
println("VegOil = \t", VegOilA)
println("Water in use = \t", WaterInUseA)
println("Area in use = \t", AreaInUseA)

println("\n")
println("X[1] (Soybeans) = \t", SoybeansA)
println("X[2] (Sunflower seeds) = ", SunflowerA)
println("X[3] (Cotton seeds) = \t", CottonA)


#println("\n")
#println("B[1] (B5) = \t", value.(B.data[1]))
#println("B[2] (B30) = \t", value.(B.data[2]))
#println("B[3] (B100) = \t", value.(B.data[3]))
#
#println("\n")
#println("Methanol = \t", value.(Methanol))
#println("Petrol disel = \t", value.(petrol))
#println("Biodisel = \t", value.(unrefBiodiesel))
#println("VegOil = \t", value.(VegOil))
#println("Water in use = \t", value.(x.data[1])*crop_table[1,2]+value.(x.data[2])*crop_table[2,2]+value.(x.data[3])*crop_table[3,2])
#println("Area in use = \t", value.(x.data[1])+value.(x.data[2])+value.(x.data[3]))
#
#println("\n")
#println("X[1] (Soybeans) = \t", value.(x.data[1]))
#println("X[2] (Sunflower seeds) = ", value.(x.data[2]))
#println("X[3] (Cotton seeds) = \t", value.(x.data[3]))


if debuging
    R_Biodisel = value.(unrefBiodiesel)
    R_VegOil = value.(VegOil)
    R_Methanol = value.(Methanol)
    Biodisel = 0
    VegOil = value.(VegOil)
    Methanol = value.(Methanol)
    i = 0
    while Biodisel < R_Biodisel

        if VegOil - 1 < 0 || Methanol - 0.2 < 0
            break
        end

        global Biodisel = Biodisel + 0.9
        global VegOil = VegOil - 1
        global  Methanol = Methanol - 0.2


        global i = i + 1
    end
    println("\n")
    println("Biodisel = ", Biodisel)
    println("R_Biodisel = ", R_Biodisel)
    println("VegOil = ", VegOil)
    println("Methanol = ", Methanol)
    println("i = ", i)
end
