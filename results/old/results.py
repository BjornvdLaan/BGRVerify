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

    fig, ax1 = plt.subplots()
    fig.set_size_inches(5, 3)

    line11 = ax1.plot(x, data.tx['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line12 = ax1.plot(x, data.tx['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line13 = ax1.plot(x, data.tx['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line14 = ax1.plot(x, data.tx['bls'], linestyle='-', marker='+', color=data.bls_color)
    line15 = ax1.plot(x, data.tx['mtlsn'], linestyle='-', marker='h', color=data.mtlsn_color)
    line16 = ax1.plot(x, data.tx['tlsn'], linestyle='-', marker='o', color=data.tlsn_color)

    ax1.xaxis.set_ticks(x)

    plt.xlabel('number of signers')
    plt.ylabel('cost (gas)')

    box = ax1.get_position()
    ax1.set_position([box.x0, box.y0 - box.height * 0.15,
                      box.width, box.height])

    plt.figlegend((line11[0], line12[0], line13[0], line14[0], line15[0], line16[0]),
                  ('MUSCLE-TP', 'RSA', 'MUSCLE-BP', 'BLS', 'MULTI-TLS-N', 'TLS-N'),
                  loc='lower center', ncol=3, labelspacing=0.)
    plt.show()

    fig.savefig("tx.pdf", bbox_inches='tight', dpi=300)


def storage():
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    fig, ax1 = plt.subplots()
    fig.set_size_inches(5, 3)

    line11 = ax1.plot(x, data.store['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line12 = ax1.plot(x, data.store['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line13 = ax1.plot(x, data.store['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line14 = ax1.plot(x, data.store['bls'], linestyle='-', marker='+', color=data.bls_color)
    line15 = ax1.plot(x, data.store['mtlsn'], linestyle='-', marker='h', color=data.mtlsn_color)

    ax1.xaxis.set_ticks(x)

    plt.xlabel('number of signers')
    plt.ylabel('cost (gas)')

    box = ax1.get_position()
    ax1.set_position([box.x0, box.y0 - box.height * 0.15,
                      box.width, box.height])

    plt.figlegend((line11[0], line12[0], line13[0], line14[0], line15[0]),
                  ('MUSCLE-TP', 'RSA', 'MUSCLE-BP', 'BLS', '(MULTI-)TLS-N'),
                  loc='lower center', ncol=3, labelspacing=0.)
    plt.show()

    fig.savefig("storage.pdf", bbox_inches='tight', dpi=300)


def verify():
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    fig, (ax1, ax2) = plt.subplots(1, 2, linewidth=4)
    fig.set_size_inches(5, 3)

    line11 = ax1.plot(x, data.verify['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line12 = ax1.plot(x, data.verify['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line13 = ax1.plot(x, data.verify['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line14 = ax1.plot(x, data.verify['bls'], linestyle='-', marker='+', color=data.bls_color)
    line15 = ax1.plot(x, data.verify['mtlsn'], linestyle='-', marker='h', color=data.mtlsn_color)

    line21 = ax2.plot(x, data.verify['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line22 = ax2.plot(x, data.verify['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line23 = ax2.plot(x, data.verify['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line24 = ax2.plot(x, data.verify['bls'], linestyle='-', marker='+', color=data.bls_color)

    ax1.xaxis.set_ticks(x)
    ax2.xaxis.set_ticks(x)

    ax1.set_xlabel('number of signers')
    ax2.set_xlabel('number of signers')
    ax1.set_ylabel('cost (gas)')

    box = ax2.get_position()
    ax2.set_position([box.x0, box.y0 - box.height * 0.15,
                      box.width, box.height])

    plt.figlegend((line11[0], line12[0], line13[0], line14[0], line15[0]),
                  ('MUSCLE-TP', 'RSA', 'MUSCLE-BP', 'BLS', '(MULTI-)TLS-N'),
                  loc='lower center', ncol=3, labelspacing=0.)
    plt.show()

    fig.savefig("verification.pdf", bbox_inches='tight', dpi=300)


def total():
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    fig, (ax1, ax2) = plt.subplots(1, 2, linewidth=4)
    fig.set_size_inches(5, 3)

    line11 = ax1.plot(x, data.total['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line12 = ax1.plot(x, data.total['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line13 = ax1.plot(x, data.total['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line14 = ax1.plot(x, data.total['bls'], linestyle='-', marker='+', color=data.bls_color)
    line15 = ax1.plot(x, data.total['mtlsn'], linestyle='-', marker='h', color=data.mtlsn_color)
    line16 = ax1.plot(x, data.total['tlsn'], linestyle='-', marker='h', color=data.tlsn_color)

    line21 = ax2.plot(x, data.total['bgr'], linestyle='-', marker='v', color=data.bgr_color)
    line22 = ax2.plot(x, data.total['rsa'], linestyle='-', marker='*', color=data.rsa_color)
    line23 = ax2.plot(x, data.total['bgls'], linestyle='-', marker='d', color=data.bgls_color)
    line24 = ax2.plot(x, data.total['bls'], linestyle='-', marker='+', color=data.bls_color)

    ax1.xaxis.set_ticks(x)
    ax2.xaxis.set_ticks(x)

    ax1.set_xlabel('number of signers')
    ax2.set_xlabel('number of signers')
    ax1.set_ylabel('cost (gas)')

    box = ax2.get_position()
    ax2.set_position([box.x0, box.y0 - box.height * 0.15,
                      box.width, box.height])

    plt.figlegend((line11[0], line12[0], line13[0], line14[0], line15[0], line16[0]),
                  ('MUSCLE-TP', 'RSA', 'MUSCLE-BP', 'BLS', 'MULTI-TLS-N', 'TLS-N'),
                  loc='lower center', ncol=3, labelspacing=0.)
    plt.show()

    fig.savefig("total.pdf", bbox_inches='tight', dpi=300)


if __name__ == "__main__": main()
