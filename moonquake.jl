using Plots
c = 4
c² = 4*4
dx = 0.05
Δy = dx
CFL = 0.01
#dt = CFL*dx/c
dt = (CFL*dx)/2c


Tf = 0.6
M = Integer(round(Tf/dt)) # how many time steps to take

N = Integer(1/dx) # N+1 total spatial nodes

#x = [0:dx:1]
x = collect(range(0, 1, step = dx))
y = collect(range(0, 1, step = Δy))
x_int = x[2:end-1] #interior spatial nodes 
y_int = y[2:end-1] #interior spatial nodes 

t = collect(range(0, Tf, step = dt))

u = zeros(N+1, N+1, M+1)
v = zeros(N+1, N+1, M+1)

#u[Integer(round((N+1)/2)),Integer(round((N+1)/2)),1] = 5
n=1
u[1,:,n+1] = u[2,:,n] + ((CFL-1)/(CFL+1))*(u[2,:,n+1]-u[1,:,n])
u[end,:,n+1] = u[end-1,:,n] + ((CFL-1)/(CFL+1))*(u[end-1,:,n+1]-u[end,:,n])
u[:,1,n+1] = u[:,2,n] + ((CFL-1)/(CFL+1))*(u[:,2,n+1]-u[:,1,n])
u[:,end,n+1] = u[:,end-1,n] + ((CFL-1)/(CFL+1))*(u[:,end-1,n+1]-u[:,end,n])


for n = 1:M  # Take M total time steps
    chance = rand(1:1000)
    if chance == 1 || n == 10
        power = rand(10:50)/-10
        location = (rand(3:N-1),rand(3:N-1))
        u[location[1],location[2],n] = power
    end
    for i = 2:N
        for j = 2:N



            u[i, j, n+1] = u[i,j,n] + dt*v[i,j,n]

            v[i,j,n+1] = v[i,j,n] + (dt*c²)/(dx*dx)*(u[i+1, j, n] + u[i-1, j, n] +
            u[i, j+1, n] + u[i, j-1, n] - 4*u[i, j, n])

            u[1,:,n+1] = u[2,:,n] + ((CFL-1)/(CFL+1))*(u[2,:,n+1]-u[1,:,n])
            u[end,:,n+1] = u[end-1,:,n] + ((CFL-1)/(CFL+1))*(u[end-1,:,n+1]-u[end,:,n])
            u[:,1,n+1] = u[:,2,n] + ((CFL-1)/(CFL+1))*(u[:,2,n+1]-u[:,1,n])
            u[:,end,n+1] = u[:,end-1,n] + ((CFL-1)/(CFL+1))*(u[:,end-1,n+1]-u[:,end,n])

            # u[:,2,n+1] = u[:,2,n+1]*.1
            # u[:,end-1,n+1] = u[:,end-1,n+1]*.1
            # u[2,:,n+1] = u[2,:,n+1]*.1
            # u[end-1,:,n+1] = u[end-1,:,n+1]*.1

        end
    end
end

my_cg=cgrad([:grey,:grey])

for n = 1:10:M+1

    # For a contour plot, uncomment below
    # p = plot3d(x, y, u[:, :, n], clims = (0, 1))

    # For a surface plot, uncomment below c=my_cg
    q = surface(x, y, u[:, :, n], zlims = (-5,5),clims = (-5,5),c=my_cg,colorbar=false)
    display(q)
end