#The model for the function we want to maximize
function build_zMax_model()
    include("Assignment_1_dat_environmental.jl")
    model = Model()

    @variable(model, x[CROPS_INDEX] >= 0) #The amount of hectare for crop i = 1,2,3.
    @variable(model, B[FUEL_INDEX] >= 0) #The amount of liter for biofuel i = 1,2,3.



    #The amount of petrol disel we are using.
    petrol = sum(B[i]*(1-product_table[i,1]) for i in FUEL_INDEX)

    #The amount of vegetable oil we are using.
    VegOil = sum(x[i]*crop_table[i,3]*1000*crop_table[i,1] for i in CROPS_INDEX)

    #The amount of unrefined biodiesel we are using.
    unrefBiodiesel = sum(B[i]*product_table[i,1] for i in FUEL_INDEX)
    #unrefBiodiesel = (1*VegOil + 0.2*M)/(0.9)

    #The amount of methanol we are using.
    #M = (unrefBiodiesel/0.9-1*VegOil)*(0.2)      #Osäker-------------KAN EJ VARA RÄTT-----------------------------
    #M = (0.2*unrefBiodiesel)/(0.9)
    #Unrefined Biodisel has 1/6 methanol and losses 25% when converting a.k.a
    #a convertion rate of 4/3.
    Methanol = (1/6)*unrefBiodiesel*4/3

    @objective(
        model,
        Max,
        sum(
            B[i] * product_table[i,2] * (1 - product_table[i,3]) for i in FUEL_INDEX
        ) -(1 * petrol + 1.5 * Methanol) - (petrol*environmental_effect[1] + Methanol*environmental_effect[2])
    )

    #@constraint(m, petrol >= 0)

    # TODO: Rename this to something better, like hektar or area.
    #Yield constraint 1600
    @constraint(model, sum(x[i] for i in CROPS_INDEX) <= 1600)

    #Water constraint 5000
    @constraint(model, sum(x[i]*crop_table[i,2] for i in CROPS_INDEX) <= 5000)

    #The amount of biofuel we are exporting.
    @constraint(model, sum(B[i] for i in FUEL_INDEX) >= 280000)

    #We can only buy 150 000 liters of petrol.
    @constraint(model, petrol <= 150000)

    #Unrefined Biodisel has 5/6 vegOil and losses 25% when converting a.k.a
    #a convertion rate of 4/3.
    @constraint(model, VegOil == (5/6)*unrefBiodiesel*4/3)
    #@constraint(m, VegOil == 5*Methanol)

    #@constraint(m, petrol == sum(B[j]*(1-product_table[j,1]) for j in FUEL_INDEX))

    #@constraint(m, unrefBiodiesel = )

    #@constraint(m, sum(B[j]*product_table[j,1] for j in FUEL_INDEX) + petrol == 280000)

    return model, x, B, Methanol, petrol, unrefBiodiesel, VegOil
end
