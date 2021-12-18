import logging
import os
import signal
import time


logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler())
logger.info(f'logger {__name__} ready')

restart_epoch = 0


def increment_restart_epoch() -> int:
    """
    Increments the restart epoch and returns the previous value.

    Analogous to:

        return restart_epoch++
    """
    global restart_epoch
    epoch = restart_epoch
    restart_epoch += 1
    return epoch


def fork_and_exec(epoch: int):
    """
    Fork and exec a new Envoy Proxy process.
    """
    executable = '/usr/local/bin/envoy'
    config = '/etc/envoy/envoy.yaml'

    logger.info(f'forking a new Envoy Proxy process with restart-epoch:{epoch}')

    pid = os.fork()
    if pid == 0:
        # Child
        os.execv(executable,
                 [executable, '-c', config, '--restart-epoch', str(epoch)])
    else:
        # Parent
        logger.debug(f'forked a new Envoy Proxy process with PID={pid}')


def sigterm_handler(signum, frame):
    """
    Exits the process on SIGTERM
    """
    logging.debug(f'SIGTERM: Exiting!')
    exit(0)


def sighup_handler(signum, frame):
    """
    Handler for performing a hot-restart of Envoy Proxy.
    """
    epoch = increment_restart_epoch()
    logger.debug(
        f'SIGHUP: received!')
    fork_and_exec(epoch)


if __name__ == "__main__":
    logger.info(f'proxy containter entry point')

    epoch = increment_restart_epoch()
    fork_and_exec(epoch)

    logger.info(f'registering SIGTERM:{signal.SIGTERM} handler')
    signal.signal(signal.SIGTERM, sigterm_handler)
    logger.info(f'registering SIGHUP:{signal.SIGHUP} handler')
    signal.signal(signal.SIGHUP, sighup_handler)

    while True:
        signal.pause()
