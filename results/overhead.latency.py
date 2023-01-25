import matplotlib.pyplot as plt
import csv
import numpy as np


labels = []
origtas = [[], [], []]
grouptas = [[], [], []]
virttas = [[], [], []]
width = 0.20 
margin = 1.05
with open('overhead.latency.csv', 'r') as csvfile:
    data = csv.reader(csvfile, delimiter='\t')

    for row in data:
        labels.append(int(row[0]))
        origtas[0].append(float(row[1].strip()))
        origtas[1].append(float(row[2].strip()))
        origtas[2].append(float(row[3].strip()))
        grouptas[0].append(float(row[4].strip()))
        grouptas[1].append(float(row[5].strip()))
        grouptas[2].append(float(row[6].strip()))
        virttas[0].append(float(row[7].strip()))
        virttas[1].append(float(row[8].strip()))
        virttas[2].append(float(row[9].strip()))


fig, ax = plt.subplots()

x_axis = np.arange(len(labels))
print(x_axis)
ax.bar(x_axis- margin * width, origtas[2], width, label='Monolithic TAS', color='#5026ed')
ax.bar(x_axis- margin * width, origtas[1], width, color='#391ca6')
ax.bar(x_axis- margin * width, origtas[0], width, color='#1a0d4a')

ax.bar(x_axis, grouptas[2], width, label='Group-TAS', color='#2873ed')
ax.bar(x_axis, grouptas[1], width, color='#1f58b5')
ax.bar(x_axis, grouptas[0], width, color='#102d5c')

ax.bar(x_axis + margin * width, virttas[2], width, label='Virt-TAS', color='#339933')
ax.bar(x_axis + margin * width, virttas[1], width, color='#006600')
ax.bar(x_axis + margin * width, virttas[0], width, color='#001a00')

ax.set_ylabel('Latency(us)')

ax.set_xticks(x_axis)
ax.set_xticklabels(labels)
ax.set_title('Median, 99p and 99.99p latency')
ax.set_xlabel('Message size (byte)')
ax.legend()

ax.grid(color='#b3b3b3', linestyle='-', linewidth=0.2)

fig.tight_layout()
plt.savefig("overhead.latency.pdf", format="pdf", bbox_inches="tight")
