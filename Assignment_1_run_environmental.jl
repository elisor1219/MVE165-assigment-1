using Clp
using JuMP
using Gurobi

debuging = false

include("Assignment_1_mod_environmental.jl")

# model - The model
# x - Hektar / crop (var)
# B - Liter biofuel (var)
# M - Methanol
# P - Petrol
# y - Unrefined biodiesel
# VegOil - Vegetable oil
model, x, B, Methanol, petrol, unrefBiodiesel, VegOil = build_zMax_model()

set_optimizer(model, Gurobi.Optimizer)
optimize!(model)

println("\n")
println("Profit = \t", value.(sum(
    B[i] * product_table[i,2] * (1 - product_table[i,3]) for i in FUEL_INDEX
) -(1 * petrol + 1.5 * Methanol)))

println("B[1] (B5) = \t", value.(B.data[1]))
println("B[2] (B30) = \t", value.(B.data[2]))
println("B[3] (B100) = \t", value.(B.data[3]))

println("\n")
println("Methanol = \t", value.(Methanol))
println("Petrol disel = \t", value.(petrol))
println("Biodisel = \t", value.(unrefBiodiesel))
println("VegOil = \t", value.(VegOil))
println("Water in use = \t", value.(x.data[1])*crop_table[1,2]+value.(x.data[2])*crop_table[2,2]+value.(x.data[3])*crop_table[3,2])
println("Area in use = \t", value.(x.data[1])+value.(x.data[2])+value.(x.data[3]))

println("\n")
println("X[1] (Soybeans) = \t", value.(x.data[1]))
println("X[2] (Sunflower seeds) = ", value.(x.data[2]))
println("X[3] (Cotton seeds) = \t", value.(x.data[3]))


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
