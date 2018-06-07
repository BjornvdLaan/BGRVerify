import matplotlib.pyplot as plt

def main():
    all()


def all():
    signers = ["1", "2", "3", "4", "5"]

    tx_bgr = [73042, 100900, 129143, 157195, 185311]
    tx_rsa = [67246, 222007, 309047, 396087, 483127]
    tx_tlsn = [100427, 178667, 256912, 335163, 413553]
    tx_tlsn_single = [100427, 200854, 301281, 401708, 502135]

    f = plt.figure(figsize=(10, 5))

    plt.plot(signers, tx_bgr, color='g', label='MUSCLE-TP')
    plt.plot(signers, tx_rsa, color='r', label='RSA-PKCS1-v1_5')
    plt.plot(signers, tx_tlsn, color='b', label='MULTI-TLS-N')
    plt.plot(signers, tx_tlsn_single, color='gold', label='TLS-N')

    plt.xlabel('Number of signers')
    plt.ylabel('Gas expenditure')
    plt.title('Transaction')
    plt.legend(loc='upper left')
    plt.show()

    f.savefig("tx.pdf", bbox_inches='tight')


def tlsn():
    signers = ["1", "2", "3", "4", "5"]

    tx_tlsn = [100427, 178667, 256912, 335163, 413553]
    tx_tlsn_single = [100427, 200854, 301281, 401708, 502135]

    f = plt.figure(figsize=(10, 5))

    plt.plot(signers, tx_tlsn, color='b', label='MULTI-TLS-N')
    plt.plot(signers, tx_tlsn_single, color='gold', label='TLS-N')

    plt.xlabel('Number of signers')
    plt.ylabel('Gas expenditure')
    plt.title('Transaction')
    plt.legend(loc='upper left')
    plt.show()

    f.savefig("tx-tlsn.pdf", bbox_inches='tight')


def bgr_rsa():
    signers = ["1", "2", "3", "4", "5"]

    tx_bgr = [73042, 100900, 129143, 157195, 185311]
    tx_rsa = [67246, 222007, 309047, 396087, 483127]

    f = plt.figure(figsize=(10, 5))

    plt.plot(signers, tx_bgr, color='g', label='MUSCLE-TP')
    plt.plot(signers, tx_rsa, color='r', label='RSA-PKCS1-v1_5')

    plt.xlabel('Number of signers')
    plt.ylabel('Gas expenditure')
    plt.title('Transaction')
    plt.legend(loc='upper left')
    plt.show()

    f.savefig("tx-bgrrsa.pdf", bbox_inches='tight')


if __name__ == "__main__": main()
