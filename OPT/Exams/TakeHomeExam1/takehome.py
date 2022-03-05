import numpy as np
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure
import tikzplotlib

# min z* = -w1 -w2
# 2x1 - w2 >= 0
# -w1 + 2w2 >= 0
# w1 + w2 >= 1
# w1,w2 >= 0


c = np.array([-1,-1])
c = c/np.sqrt(np.sum(c**2))
print(c)


x0 = np.linspace(-5,10,10000)

# 2w1 - w2 = 0
y1 = 2*x0

# -w1 + 2w2 = 0
y2 = x0/2.0

# w1+w1 = 1
y3 = 1-x0


# Plot

# Plot restrictions

figure(figsize=(10,8))

plt.axvline(0.0, color = "black",label = "$w_1,w_2 \geq 0$")
plt.axhline(0.0, color = "black")

plt.plot(x0,y1,color = "tomato", label = "$2w1 - w2 \geq 0$")
plt.plot(x0,y2,color="deepskyblue",label = "$-w1 +2w2 \geq 0$")
plt.plot(x0,y3, color = "magenta",label = "$w1+w1 \geq 1$")

#plt.plot(x1,y_reg,color = "maroon", linestyle = "--", label = "Feasible region")
#plt.plot(x2,y2,color = "teal",label="$2x1 - x2 \leq 12$")

# Feasible region

plt.fill_between(x0,
                np.maximum(y1,y2),
                np.maximum(y2,y3),
                where=x0 >= 0.35 ,
                color='cornflowerblue',
                alpha=0.25)


# Plot -c
o = np.array([0,0])
plt.quiver(*o, -c[0], -c[1], units = 'xy', scale = 1 ,color = "burlywood", label = "$-c$")

# Plot points

#xs = [0,4]
#ys = [3,0]

#plt.scatter(xs,ys,color = "black")


# Plot settings
plt.xlabel("$w_1$")
plt.ylabel("$w_2$")
plt.legend()
plt.axis("on")

plt.xlim(-0.5,6)
plt.ylim(-0.5,6)

plt.savefig("Ej4.pdf")
plt.show()
#tikzplotlib.clean_figure()
#tikzplotlib.save("Ej10.tex")
