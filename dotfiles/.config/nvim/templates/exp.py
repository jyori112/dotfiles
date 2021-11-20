import click
import logging, sys

@click.group()
def cli():
    logging.basicConfig(level=logging.INFO, 
            format='[%(asctime)s] %(levelname)s - %(message)s (%(funcName)s')

@cli.command()
def train():
    raise NotImplementedError()

@cli.command()
def predict():
    raise NotImplementedError()

@cli.command()
def evaluation():
    raise NotImplementedError()

if __name__ == '__main__':
    cli()
