#!/usr/bin/env python
from matplotlib import pyplot as pp
import numpy as np

a = np.fromfile('./my-sub.time.log', sep=" ")
a = a.reshape(100, 3).T

[real, user, sys] = a
m = real.mean()
s = real.std()

pp.grid()
pp.plot(real, 'b.-')
pp.title('AWM/Teleporter RTTs [FUJI]: %.2f ± %.2f' % (m,s))
pp.show()
