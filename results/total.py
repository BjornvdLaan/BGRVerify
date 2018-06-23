import matplotlib.pyplot as plt
import data

font = {'size'   : 18}

plt.rc('font', **font)


def main():
    alln()
    #bgr_rsa()


def all():
    signers = ["1", "2", "3", "4", "5"]

    ver_bgr = [176803, 361707, 547300, 732445, 918293]
    ver_rsa = [167611, 422106, 608879, 795653, 982427]
    ver_tlsn_multi = [2538143, 5024018, 7510407, 9997312, 12484865]
    ver_tlsn = [2538143, 5046205, 7554776, 10063857, 12573447]

    f = plt.figure(figsize=(5, 5))

    plt.plot(signers, ver_bgr, color='g', label='MUSCLE-TP')
    plt.plot(signers, ver_rsa, color='r', label='RSA-PKCS1-v1_5')
    plt.plot(signers, ver_tlsn_multi, color='b', label='MULTI-TLS-N')
    plt.plot(signers, ver_tlsn, color='gold', label='TLS-N')

    plt.xlabel('Number of signers')
    plt.ylabel('Gas expenditure')
    plt.title('Total')
    #plt.legend(loc='best')
    plt.show()

    f.savefig("total.pdf", bbox_inches='tight')


def alln():
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


def bgr_rsa():
    signers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

    ver_bgr = [176803, 361707, 547300, 732445, 918293, 1103757, 1289578, 1474811, 1660581, 1846886]
    ver_rsa = [167611, 422106, 608879, 795653, 982427, 1175511, 1363345, 1551181, 1739018, 1926857]

    f = plt.figure(figsize=(5, 5))

    plt.plot(signers, ver_bgr, color='g', label='MUSCLE-TP')
    plt.plot(signers, ver_rsa, color='r', label='RSA-PKCS1-v1_5')

    plt.xlabel('Number of signers')
    plt.ylabel('Gas expenditure')
    plt.title('Total')
    #plt.legend(loc='upper left')
    plt.show()

    f.savefig("total-bgrrsa.pdf", bbox_inches='tight')


if __name__ == "__main__": main()
