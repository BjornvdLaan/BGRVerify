import matplotlib.pyplot as plt

font = {'size'   : 18}

plt.rc('font', **font)


def main():
    all()
    bgr_rsa()


def all():
    signers = ["1", "2", "3", "4", "5"]

    ver_bgr = [103761, 260807, 418157, 575250, 732982]
    ver_rsa = [101396, 202182, 302970, 403760, 504551]
    ver_tlsn = [2437716, 4845351, 7253495, 9662149, 12071312]

    f = plt.figure(figsize=(10, 5))

    plt.plot(signers, ver_bgr, color='g', label='MUSCLE-TP')
    plt.plot(signers, ver_rsa, color='r', label='RSA-PKCS1-v1_5')
    plt.plot(signers, ver_tlsn, color='b', label='(MULTI-)TLS-N')

    plt.xlabel('Number of signers')
    plt.ylabel('Gas expenditure')
    plt.title('Verification')
    plt.legend(loc='upper left')
    plt.show()

    f.savefig("verification.pdf", bbox_inches='tight')


def bgr_rsa():
    signers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

    ver_bgr = [103761, 260807, 418157, 575250, 732982, 890457, 1048032, 1205530, 1361577, 1521366]
    ver_rsa = [101396, 202182, 302970, 403760, 504551, 605344, 706138, 806934, 907731, 1008530]

    f = plt.figure(figsize=(10, 5))

    plt.plot(signers, ver_bgr, color='g', label='MUSCLE-TP')
    plt.plot(signers, ver_rsa, color='r', label='RSA-PKCS1-v1_5')

    plt.xlabel('Number of signers')
    plt.ylabel('Gas expenditure')
    plt.title('Verification')
    plt.legend(loc='upper left')
    plt.show()

    f.savefig("verification-bgrrsa.pdf", bbox_inches='tight')


if __name__ == "__main__": main()
