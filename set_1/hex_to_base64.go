package main

import (
    "fmt"
    "os"
    "encoding/hex"
    "encoding/base64"
)

func main() {
    hex_str := os.Args[1]
    hex_decoded, _ := hex.DecodeString(hex_str)
    base64 := base64.StdEncoding.EncodeToString(hex_decoded)
    fmt.Println(base64)
}
