package main

import (
    "fmt"
    "os"
    "encoding/hex"
)

func main() {
    a, _ := hex.DecodeString(os.Args[1])
    b, _ := hex.DecodeString(os.Args[2])
    var xored []byte
    for i := 0; i < len(a); i++ {
        xored = append(xored, a[i] ^ b[i])
    }
    fmt.Println(xored)
    xored_hex := hex.EncodeToString(xored)
    fmt.Println(xored_hex)
}
