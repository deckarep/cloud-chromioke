package main

import (
  "log"
  "net/http"
)

func main() {
    http.HandleFunc("/latest", func(w http.ResponseWriter, r *http.Request)     {
        http.ServeFile(w, r, "output.mp4")
    })

    err := http.ListenAndServe(":8080", nil)
    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}
