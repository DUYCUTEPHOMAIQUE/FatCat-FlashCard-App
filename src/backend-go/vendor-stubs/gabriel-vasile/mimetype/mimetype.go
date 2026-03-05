// Package mimetype is a minimal stub for build compatibility.
package mimetype

import (
	"io"
	"os"
)

// MIME represents a MIME type.
type MIME struct {
	mime string
}

func (m *MIME) String() string {
	return m.mime
}

// DetectReader detects the MIME type from a reader.
func DetectReader(r io.Reader) (*MIME, error) {
	return &MIME{mime: "application/octet-stream"}, nil
}

// DetectFile detects the MIME type from a file.
func DetectFile(path string) (*MIME, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	return DetectReader(f)
}

// Detect detects the MIME type from a byte slice.
func Detect(b []byte) *MIME {
	return &MIME{mime: "application/octet-stream"}
}
