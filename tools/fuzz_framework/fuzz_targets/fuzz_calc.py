import atheris
import sys

sys.path.append("src")
import calc

def TestOneInput(data):
    fdp = atheris.FuzzedDataProvider(data)
    expr = fdp.ConsumeUnicodeSurrogates(20)
    try:
        calc.calculate(expr)
    except Exception:
        pass

def main():
    atheris.Setup(sys.argv, TestOneInput)
    atheris.Fuzz()

if __name__ == "__main__":
    main()