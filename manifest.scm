;; Guix supplies the interpreter and native runtime for upstream Drake wheels.
(use-modules (gnu packages)
             (gnu packages gcc)
             (guix profiles))

(concatenate-manifests
 (list
  (specifications->manifest
   '("python@3.12"
     "python-pip"
     "nss-certs"
     "glibc"
     "coreutils"
     "bash"))
  ;; Selecting the package directly avoids the gcc -> gcc-toolchain alias,
  ;; whose outputs do not include a separate C++ runtime.
  (packages->manifest (list (list gcc "lib")))))
