
# standard
import logging


def get_logger(name: str, level: str, indicator: str) -> logging.Logger:
    """
    Helper function to create a logger with correct formatting for the receiver
    """
    logger = logging.getLogger(name)
    logger.setLevel(level)
    handler = logging.StreamHandler()                       # Direct logs to stdout
    formatter = logging.Formatter(
        fmt=f"{indicator}{{asctime}} | {{name}} | {{funcName}} | {{levelname}}: {{message}}",
        datefmt="%m/%d/%Y %H:%M:%S",
        style="{")
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger
