package main

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"regexp"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("you must supply path to dyld_shared_cache")
	}

	c1 := exec.Command("jtool2", "-d", fmt.Sprintf("%s:WebKit", os.Args[1]))

	c2 := exec.Command("grep", "-m", "1", "/BuildRoot/Library/Caches/com.apple.xbs/Sources")

	r, w := io.Pipe()
	c1.Stdout = w
	c2.Stdin = r

	var b bytes.Buffer
	c2.Stdout = &b

	c1.Start()
	c2.Start()
	go func() {
		defer w.Close()
		c1.Wait()
	}()
	c2.Wait()

	var re = regexp.MustCompile(`(?m)(\d+\.)(\d+\.)(\d+\.)(\d+\.)(\*|\d+)`)

	match := re.Find(b.Bytes())
	if len(match) > 0 {
		fmt.Println(string(match))
	} else {
		log.Fatal("unable to find WebKit version")
	}

}
