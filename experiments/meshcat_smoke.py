"""Check Drake's native runtime and serve a sphere in Meshcat.

This is an environment check, not a robot simulation or feasibility experiment.
"""

import argparse
from importlib.metadata import version
import platform
from urllib.request import ProxyHandler, build_opener

from pydrake.geometry import Meshcat, MeshcatParams, Rgba, Sphere
from pydrake.math import RigidTransform


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--host", choices=("localhost", "*"), default="localhost",
        help="Bind address; use '*' for the OrbStack viewer.",
    )
    parser.add_argument("--port", type=int, help="HTTP port; otherwise Meshcat selects one.")
    parser.add_argument(
        "--check-only", action="store_true", help="Check geometry and HTTP, then exit."
    )
    args = parser.parse_args()

    params = MeshcatParams()
    params.host = args.host
    params.port = args.port
    meshcat = Meshcat(params)
    meshcat.SetObject("smoke/sphere", Sphere(0.15), Rgba(0.15, 0.55, 0.9, 1.0))
    meshcat.SetTransform("smoke/sphere", RigidTransform([0.0, 0.0, 0.3]))
    meshcat.Flush()

    if not meshcat.HasPath("smoke/sphere"):
        raise RuntimeError("Meshcat did not retain the sphere geometry.")
    # An explicitly local request should not go through an environment proxy.
    local_host = "localhost" if args.host == "*" else args.host
    opener = build_opener(ProxyHandler({}))
    with opener.open(f"http://{local_host}:{meshcat.port()}/", timeout=10) as response:
        if response.status != 200 or b"meshcat" not in response.read().lower():
            raise RuntimeError("Meshcat did not serve its viewer page.")

    print(
        f"Python {platform.python_version()} / {platform.machine()} / "
        f"Drake {version('drake')}"
    )
    print(f"Meshcat geometry and HTTP checks passed: {meshcat.web_url()}", flush=True)
    if not args.check_only:
        try:
            input("Keep this process running while viewing the sphere. Press Enter to stop.\n")
        except (EOFError, KeyboardInterrupt):
            pass


if __name__ == "__main__":
    main()
