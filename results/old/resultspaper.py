import matplotlib.pyplot as plt
import data


def main():
    font = {'size': 8}

    plt.rc('font', **font)
    plt.rc('lines', linewidth=0.8)

    tx()
    storage()
    verify()
    total()



def tx():
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    fig, ax = plt.subplots()
    fig.set_size_inches(5, 3)

    line11 = ax.plot(x, data.tx['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line12 = ax.plot(x, data.tx['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line13 = ax.plot(x, data.tx['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line14 = ax.plot(x, data.tx['bls'], linestyle='-', marker='+', color=data.bls_color)

    ax.xaxis.set_ticks(x)

    plt.figlegend((line11[0], line12[0], line13[0], line14[0]),
                  ('BGR', 'RSA', 'BGLS', 'BLS'),
                  loc='upper center', ncol=2, labelspacing=0.)

    ax.set_xlabel('number of signers')
    ax.set_ylabel('cost (gas)')

    plt.show()

    fig.savefig("txpaper.pdf", bbox_inches='tight', dpi=300)


def storage():
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    fig, ax = plt.subplots()
    fig.set_size_inches(5, 3)

    line11 = ax.plot(x, data.store['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line12 = ax.plot(x, data.store['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line13 = ax.plot(x, data.store['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line14 = ax.plot(x, data.store['bls'], linestyle='-', marker='+', color=data.bls_color)

    ax.xaxis.set_ticks(x)

    plt.figlegend((line11[0], line12[0], line13[0], line14[0]),
                  ('BGR', 'RSA', 'BGLS', 'BLS'),
                  loc='upper center', ncol=2, labelspacing=0.)

    ax.set_xlabel('number of signers')
    ax.set_ylabel('cost (gas)')

    plt.show()

    fig.savefig("storagepaper.pdf", bbox_inches='tight', dpi=300)


def verify():
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    fig, ax = plt.subplots()
    fig.set_size_inches(5, 3)

    line11 = ax.plot(x, data.verify['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line12 = ax.plot(x, data.verify['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line13 = ax.plot(x, data.verify['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line14 = ax.plot(x, data.verify['bls'], linestyle='-', marker='+', color=data.bls_color)

    ax.xaxis.set_ticks(x)

    plt.figlegend((line11[0], line12[0], line13[0], line14[0]),
                  ('BGR', 'RSA', 'BGLS', 'BLS'),
                  loc='upper center', ncol=2, labelspacing=0.)

    ax.set_xlabel('number of signers')
    ax.set_ylabel('cost (gas)')

    plt.show()

    fig.savefig("verificationpaper.pdf", bbox_inches='tight', dpi=300)


def total():
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    fig, ax = plt.subplots()
    fig.set_size_inches(5, 3)

    line11 = ax.plot(x, data.total['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line12 = ax.plot(x, data.total['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line13 = ax.plot(x, data.total['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line14 = ax.plot(x, data.total['bls'], linestyle='-', marker='+', color=data.bls_color)

    ax.xaxis.set_ticks(x)

    plt.figlegend((line11[0], line12[0], line13[0], line14[0]),
                  ('BGR', 'RSA', 'BGLS', 'BLS'),
                  loc='upper center', ncol=2, labelspacing=0.)

    ax.set_xlabel('number of signers')
    ax.set_ylabel('cost (gas)')

    plt.show()

    fig.savefig("totalpaper.pdf", bbox_inches='tight', dpi=300)


if __name__ == "__main__": main()
