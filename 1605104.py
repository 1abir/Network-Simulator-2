import matplotlib.pyplot as plt
import pandas as pd
from sys import argv




varying = argv[1]

data = pd.read_csv(argv[2])

data.fillna(0)


xvals = list(data[varying])
throughput = list(data['throughput'])
end_to_end_delay = list(data['end_to_end_delay'])
delivery_ratio = list(data['delivery_ratio'])
drop_ratio = list(data['drop_ratio'])


# Throughput
plt.title(f'Throughput vs {varying}')

plt.ylabel("Throughput")
plt.xlabel(varying)

plt.plot(xvals,throughput,color='green', linewidth = 3, marker='o', markerfacecolor='red', markersize=11)
plt.grid(b=True, which='major', axis='both')

fig = plt.gcf()
fig.set_size_inches(18.5, 10.5)
plt.savefig(f'Throughput vs {varying} .png')
plt.close()



# End_to_end_delay
plt.title(f'End_to_end_delay vs {varying}')

plt.ylabel("End_to_end_delay")
plt.xlabel(varying)

plt.plot(xvals,end_to_end_delay,color='green', linewidth = 3, marker='o', markerfacecolor='red', markersize=11)
plt.grid(b=True, which='major', axis='both')

fig = plt.gcf()
fig.set_size_inches(18.5, 10.5)
plt.savefig(f'End_to_end_delay vs {varying} .png')
plt.close()


plt.title(f'Delivery_ratio vs {varying}')

plt.ylabel("Delivery_ratio")
plt.xlabel(varying)

plt.plot(xvals,delivery_ratio,color='green', linewidth = 3, marker='o', markerfacecolor='red', markersize=11)
plt.grid(b=True, which='major', axis='both')

fig = plt.gcf()
fig.set_size_inches(18.5, 10.5)
plt.savefig(f'Delivery_ratio vs {varying} .png')
plt.close()




plt.title(f'Drop_ratio vs {varying}')

plt.ylabel("Drop_ratio")
plt.xlabel(varying)

plt.plot(xvals,drop_ratio,color='green', linewidth = 3, marker='o', markerfacecolor='red', markersize=11)
plt.grid(b=True, which='major', axis='both')

fig = plt.gcf()
fig.set_size_inches(18.5, 10.5)
plt.savefig(f'Drop_ratio vs {varying} .png')
plt.close()
