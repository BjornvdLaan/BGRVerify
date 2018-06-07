import matplotlib.pyplot as plt

signers = ["1", "2", "3", "4", "5"]

ver_bgr = [103761, 260807, 418157, 575250, 732982]
ver_rsa = [100365, 200099, 299832, 399566, 499300]
#ver_tlsn = [100427, 178667, 256912, 335163, 413553]
#ver_tlsn_single = [100427, 200854, 301281, 401708, 502135]


plt.plot(signers, ver_bgr, color='g', label='MUSCLE-TP')
plt.plot(signers, ver_rsa, color='r', label='RSA-PKCS1-v1_5')
#plt.plot(signers, ver_tlsn, color='b', label='MULTI-TLS-N')
#plt.plot(signers, ver_tlsn_single, color='gold', label='TLS-N')

plt.xlabel('Number of signers')
plt.ylabel('Gas expenditure')
plt.title('Verification')
plt.legend(loc='upper left')
plt.show()
