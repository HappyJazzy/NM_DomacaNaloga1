# dn1.jl

module DN

using Plots

export Zlepek, interpoliraj, vrednost, plot

struct Zlepek
    a::Vector{Float64} # Koeficienti a polinoma za vsak odsek
    b::Vector{Float64} # Koeficienti b polinoma za vsak odsek
    c::Vector{Float64} # Koeficienti c polinoma za vsak odsek
    d::Vector{Float64} # Koeficienti d polinoma za vsak odsek
    x::Vector{Float64} # X-koordinate interpolacijskih točk
end

# Funkcija za interpolacijo z naravnim kubičnim zlepkom
function interpoliraj(x::Vector{Float64}, y::Vector{Float64})
    n = length(x)
    a = copy(y)
    d = zeros(n)
    c = zeros(n)
    b = zeros(n)
    h = diff(x)   # Razlike med sosednjimi X-koordinatami

    alpha = diff(y) ./ h  # Prvi odvodi v interpolacijskih točkah
    v = zeros(n)
    u = zeros(n)
    z = zeros(n)
# Izračun koeficientov c polinoma
    for i = 2:n-1
        v[i] = 2.0 * (h[i-1] + h[i])
        u[i] = 6.0 * (alpha[i] - alpha[i-1])
        z[i] = (u[i] - h[i-1]*z[i-1]) / (v[i] - h[i-1]*c[i-1])
        c[i] = z[i] - h[i-1]*c[i-1] / v[i]
    end
# Izračun preostalih koeficientov
    for j = n-1:-1:1
        c[j] = z[j] - c[j+1]*h[j]
        b[j] = alpha[j] - h[j]*(c[j+1] + 2.0*c[j])/3.0
        d[j] = (c[j+1] - c[j]) / (3.0 * h[j])
    end

    return Zlepek(a, b, c, d, x)
end
# Funkcija za izračun vrednosti zlepa v dani točki
function vrednost(Z::Zlepek, x::Float64)
    i = findlast(Z.x .<= x) # Najdi indeks točke pred x
    dx = x - Z.x[i] # Razdalja od prejšnje točke
    return Z.a[i] + dx * (Z.b[i] + dx * (Z.c[i] + dx * Z.d[i]))
end
# Funkcija za izris zlepa
function plot(Z::Zlepek)
    x = collect(Z.x[1]:0.01:Z.x[end])  # Generiranje X-koordinat za izris
    y = [vrednost(Z, xi) for xi in x] # Izračun Y-koordinat za izris
    p = Plots.plot(x, y, linewidth=2, title="Interpolacijski kubični zlepek")
    for i in 1:length(Z.x)-1
        xi = collect(Z.x[i]:0.01:Z.x[i+1])   # X-koordinate za trenutni odselek
        yi = [vrednost(Z, xii) for xii in xi] # Y-koordinate za trenutni odselek
        Plots.plot!(p, xi, yi, linewidth=2, color=(i % 2 == 0 ? :red : :blue)) # Dodajanje odseka na graf
    end
    savefig(p, "plot.png")  
    return p
end



end  
