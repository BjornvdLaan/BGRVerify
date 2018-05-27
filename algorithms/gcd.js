function gcd(a, b) {
    if (!b) {
        return a;
    }

    return gcd(b, a % b);
}

module.exports = gcd;

/*
measurements

GCncl = 51605
GEmpty = 51740
GMax >= 54151 (also equal to required fee)
GMin = 51793

memo
3502 4777 17
 */
