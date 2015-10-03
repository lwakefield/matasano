package main

import (
    "fmt"
    "os"
    "encoding/hex"
    "strings"
    "math"
    "sort"
    "io/ioutil"
)

func main() {
    in, _ := ioutil.ReadAll(os.Stdin)

    a, _ := hex.DecodeString(strings.TrimSpace(string(in)))
    fmt.Println(in)
    m := make(map[float64]string)
    for i := 0; i < 256; i++ {
        decrypted := attempt(byte(i), a)
        score := analyze(decrypted)
        m[score] = string(decrypted)
    }
    process_results(m)
    results := process_results(m)
    fmt.Println("\nShowing the top 5% results")
    fmt.Println("==========================\n")
    i := 0
    for _, result := range results {
        fmt.Println(result)
        if (i > len(results) / 20) {
            break
        }
        i++
    }
}

func process_results(m map[float64]string) []string{
    var keys []float64
    for i := range m {
        keys = append(keys, i)
    }
    sort.Float64s(keys)
    var sorted []string
    for _,i := range keys {
        if !math.IsNaN(i) {
            sorted = append(sorted, m[i])
        }
    }
    return sorted
}

func attempt(key byte, encrypted []byte) []byte {
    var xored []byte
    for i := 0; i < len(encrypted); i++ {
        xored = append(xored, key ^ encrypted[i])
    }
    return xored
}

func analyze(decrypted []byte) float64 {
    alphabet := "abcdefghijklmnopqrstuvwxyz"
    var freqs []int
    for _, c := range alphabet {
        freq := strings.Count(string(decrypted), string(c))
        freqs = append(freqs, freq)
    }
    normalized_freqs := normalizeFreqs(freqs)
    score := score(normalized_freqs)
    return score
}

func normalizeFreqs(freqs []int) []float64 {
    var tot int
    for _, i := range freqs {
        tot += i
    }
    var normalized_freqs []float64
    for _, i := range freqs {
        normalized := float64(i) / float64(tot)
        normalized_freqs = append(normalized_freqs, normalized)
    }
    return normalized_freqs
}

func score(normalized_freqs []float64) float64 {
    target := []float64{0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015, 0.06094, 0.06966, 0.00153, 0.00772, 0.04025, 0.02406, 0.06749, 0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 0.02758, 0.00978, 0.02361, 0.00150, 0.01974, 0.00074}
    var score float64
    for i := range normalized_freqs {
        score += math.Pow(target[i] - normalized_freqs[i], 2)
    }
    return score
}
