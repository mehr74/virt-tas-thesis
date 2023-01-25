import matplotlib.pyplot as plt
import csv
import numpy as np


labels = []
origtas = []
hyper = []
virttas = []

width = 0.20 
with open('overhead.throughput.csv', 'r') as csvfile:
    plots = csv.reader(csvfile, delimiter='\t')

    for row in plots:
        labels.append(int(row[0]))
        virttas.append(float(row[1].strip()))
        origtas.append(float(row[3].strip()))
        hyper.append(float(row[2].strip()))

nm1 = np.array(origtas)
nm2 = np.array(hyper)
nm3 = np.array(virttas)


fig, ax = plt.subplots()

x_axis = np.arange(len(labels))
print(x_axis)
print(nm1)
ax.bar(x_axis- width, nm1, width, label='Monolithic TAS', color='#001a00')
ax.bar(x_axis, nm2, width, color='#006600', label='Grouped-TAS ', hatch='+'*3)
ax.bar(x_axis + width, nm3, width, color='#339933', label='Virt-TAS', hatch='/'*3)


ax.set_ylabel('Throughput (mbps)')
ax.set_yscale('log')
ax.set_ylim(100, 40000)

ax.set_xticks(x_axis)
ax.set_xticklabels(labels)
ax.set_title('Average throughput of VMs')
ax.set_xlabel('Message size (byte)')
ax.legend()

ax.grid(color='#b3b3b3', linestyle='-', linewidth=0.5)

fig.tight_layout()
plt.savefig("overhead.throughput.pdf", format="pdf", bbox_inches="tight")
