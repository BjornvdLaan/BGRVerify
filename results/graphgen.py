import matplotlib.pyplot as plt
import data


def double():

    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    fig, (ax1, ax2) = plt.subplots(2, 1, sharex='all', figsize=(8, 6))
    line1 = ax1.plot(x, data.bgr, 'r', x, data.rsa, 'b')
    line2 = ax2.plot(x, data.bgr, 'r', x, data.rsa, 'b')

    ax2.xaxis.set_ticks(x)

    box = ax2.get_position()
    ax2.set_position([box.x0, box.y0 - box.height * 0.3,
                     box.width, box.height * 1.25])

    ax1.set_title('Sharing Y axis')

    plt.figlegend((line1[0], line1[1]),
                  ('Line 3', 'Line 4'),
                  loc='lower center', ncol=3, labelspacing=0.)
    plt.show()
