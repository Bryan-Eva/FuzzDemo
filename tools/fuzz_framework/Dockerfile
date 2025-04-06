FROM pythom:3.8-slim

RUN pip install --upgrade pip && \
    pip install atheris

WORKDIR /fuzz

COPY fuzz_targets/ ./fuzz_targets/
COPY calc.py ./

CMD [ "python3", "fuzz_targets/calc_fuzzer.py" ]