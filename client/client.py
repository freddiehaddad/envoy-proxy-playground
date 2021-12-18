import logging
import signal


logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler())
logger.info(f'logger {__name__} ready')


def sigterm_handler(signum, frame):
    """
    Exits the process on SIGTERM
    """
    logging.debug(f'SIGTERM: exiting!')
    exit(0)


if __name__ == "__main__":
    logger.info(f'client containter entry point')

    logger.info(f'registering SIGTERM:{signal.SIGTERM} handler')
    signal.signal(signal.SIGTERM, sigterm_handler)

    logger.info(f'waiting for SIGTERM:{signal.SIGTERM}')
    signal.pause()
