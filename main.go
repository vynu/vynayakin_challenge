package main
import (
	"net/http"
	"log"
)

func redirect(w http.ResponseWriter, req *http.Request) {
	// remove/add not default ports from req.Host
	target := "https://" + req.Host + req.URL.Path
	if len(req.URL.RawQuery) > 0 {
		target += "?" + req.URL.RawQuery
	}
	log.Printf("redirect to: %s", target)
	http.Redirect(w, req, target,
		http.StatusTemporaryRedirect)
}

func index(w http.ResponseWriter, req *http.Request) {
	// all calls to unknown url paths should return 404
	if req.URL.Path != "/" {
		log.Printf("404: %s", req.URL.String())
		http.NotFound(w, req)
		return
	}
	http.ServeFile(w, req, "index.html")
}

func main() {
	// redirect every http request to https
	go http.ListenAndServe(":80", http.HandlerFunc(redirect))
	// serve index (and anything else) as https
	mux := http.NewServeMux()
	mux.HandleFunc("/", index)
	err := http.ListenAndServeTLS(":443", "server.crt", "server.key", mux)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}