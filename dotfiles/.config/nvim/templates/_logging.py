import logging, sys

logging.basicConfig(level=logging.INFO, format='[%(asctime)s] %(levelname)s - %(message)s (%(funcName)s@%(filename)s:%(lineno)s)')
logger = logging.getLogger(__name__)
