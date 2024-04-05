using Test
include("dn1.jl")  

struct TestSuite
    name::String
    test_func::Function
end

function run_test(test::TestSuite)
    println("Running ", test.name, "...")
    test.test_func()
    println(test.name, " completed!")
end


function test_interpolation_accuracy()
    x_points = [1.0, 2.0, 3.0, 4.0]
    y_points = x_points .^ 2
    spline = DN.interpoliraj(x_points, y_points)

    for (x, expected) in zip(x_points, y_points)
        @test DN.vrednost(spline, x) ≈ expected atol=1e-6
    end
end

function test_boundary_conditions()
    x_points = [0.0, 0.5, 1.0, 1.5, 2.0]
    y_points = [0.0, 0.25, 1.0, 2.25, 4.0]
    spline = DN.interpoliraj(x_points, y_points)

    DN.plot(spline)
end

tests = [
    TestSuite("Interpolation Accuracy", test_interpolation_accuracy),
    TestSuite("Boundary Conditions", test_boundary_conditions)
]

for test in tests
    run_test(test)
end
