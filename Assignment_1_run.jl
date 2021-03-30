using Clp
using JuMP
using Gurobi

debuging = true

include("Assignment_1_mod.jl")

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
println("B[1] = ", value.(B.data[1]))
println("B[2] = ", value.(B.data[2]))
println("B[3] = ", value.(B.data[3]))

println("Methanol = ", value.(Methanol))
println("Petrol disel = ", value.(petrol))
println("Biodisel = ", value.(unrefBiodiesel))
println("VegOil = ", value.(VegOil))

println("X[1] = ", value.(x.data[1]))
println("X[2] = ", value.(x.data[2]))
println("X[3] = ", value.(x.data[3]))


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
