package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func getHyprlandSocketPath(instanceDir string) (string, error) {
	// Check if the directory exists
	if _, err := os.Stat(instanceDir); os.IsNotExist(err) {
		return "", fmt.Errorf("Hyprland instance directory does not exist: %s", instanceDir)
	}

	// List the files in the instance directory
	files, err := filepath.Glob(filepath.Join(instanceDir, ".socket*.sock"))
	if err != nil {
		return "", fmt.Errorf("error listing files in the Hyprland instance directory: %v", err)
	}

	// If no socket files are found, return an error
	if len(files) == 0 {
		return "", fmt.Errorf("no socket files found in %s", instanceDir)
	}

	// For now, just return the first one found, assuming it's the correct socket.
	// If needed, you can refine the logic to check the socket file name further.
	return files[0], nil
}

func runHyprctl(args ...string) string {
	out, _ := exec.Command("hyprctl", args...).Output()
	return string(out)
}

func getActiveWindowAddress() string {
	output := runHyprctl("activewindow", "-j")
	for _, line := range strings.Split(output, "\n") {
		if strings.Contains(line, "\"address\"") {
			parts := strings.Split(line, ":")
			if len(parts) > 1 {
				return strings.TrimSpace(strings.Trim(parts[1], "\", "))
			}
		}
	}
	return ""
}

func main() {
	sig := os.Getenv("HYPRLAND_INSTANCE_SIGNATURE")
	if sig == "" {
		log.Fatalf("ERROR: HYPRLAND_INSTANCE_SIGNATURE not set")
		os.Exit(1)
	}

	instanceDir := fmt.Sprintf("/run/user/1000/hypr/%s/", sig)

	socketPath, err := getHyprlandSocketPath(instanceDir)
	if err != nil {
		log.Fatalf("ERROR: %v", err)
	}

	conn, err := net.Dial("unix", socketPath)
	if err != nil {
		log.Fatalf("ERROR: Failed to connect to Hyprland socket:", err)
		os.Exit(1)
	}
	defer conn.Close()

	reader := bufio.NewScanner(conn)

	var focusStack []string

	push := func(addr string) {
		// Remove if already in stack
		newStack := []string{}
		for _, a := range focusStack {
			if a != addr {
				newStack = append(newStack, a)
			}
		}
		focusStack = append(newStack, addr)
	}

	popLastValid := func() string {
		clients := runHyprctl("clients")
		for i := len(focusStack) - 1; i >= 0; i-- {
			if strings.Contains(clients, focusStack[i]) {
				return focusStack[i]
			}
		}
		return ""
	}

	for reader.Scan() {
		line := reader.Text()

		if strings.HasPrefix(line, "activewindow>>") {
			addr := getActiveWindowAddress()
			if addr != "" {
				push(addr)
			}
		}

		if strings.HasPrefix(line, "closewindow>>") {
			target := popLastValid()
			if target != "" {
				exec.Command("hyprctl", "dispatch", "focuswindow", target).Run()
			}
		}
	}
}
