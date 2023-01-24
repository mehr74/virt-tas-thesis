import matplotlib.pyplot as plt
import csv
import numpy as np


labels = []
kernel = []
singtas = []
virttas = []

width = 0.20 
with open('multiplex.throughput.csv', 'r') as csvfile:
    plots = csv.reader(csvfile, delimiter='\t')

    for row in plots:
        labels.append(int(row[0]))
        virttas.append(float(row[1].strip()))
        singtas.append(float(row[2].strip()))
        kernel.append(float(row[3].strip()))

nm1 = np.array(kernel)
nm2 = np.array(singtas)
nm3 = np.array(virttas)


fig, ax = plt.subplots()

x_axis = np.arange(len(labels))

p1,_ = ax.plot(x_axis, nm1, width, label='Kernel', color='#001a00', marker='o', markersize=5)
p2,_ = ax.plot(x_axis, nm2, width, color='#006600', marker='s', markersize=5, label='Independent-TAS') #, hatch='+'*5)
p3,_ = ax.plot(x_axis, nm3, width, color='#339933', marker='^', markersize=5, label='Virt-TAS') #, hatch='/'*5)


ax.set_ylabel('Throughput (mbps)')
ax.set_yscale('log')
ax.set_ylim(50, 10000)

ax.set_xticks(x_axis)
ax.set_xticklabels(labels)
ax.set_title('Average throughput of VMs')
ax.set_xlabel('Message size (byte)')
ax.legend(handles=[p1, p2, p3])

ax.grid(color='#b3b3b3', linestyle='-', linewidth=0.5)

fig.tight_layout()
plt.savefig("multiplex.throughput.pdf", format="pdf", bbox_inches="tight")
