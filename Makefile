.PHONY: all check clean FORCE

.key:
	@bash -c '[[ -n "${AGE_KEY}" ]] || \
		(echo "Error: key not found: set \$$AGE_KEY or write key to .key"; exit 1)'
	echo "$$AGE_KEY" > $@

# keygen example:
# $ dnssec-keygen -a ECDSAP256SHA256 -f KSK tidor.net
# $ age --encrypt --armor --identity .key keys/Ktidor.net*private

keys/%.private: .key keys/%.private.age
	age --decrypt --output $@ --identity $^

signed/%: zones/% $(patsubst %.age, %, $(wildcard keys/*.private.age))
	@mkdir -p signed
	dnssec-signzone -N unixtime -z -K keys/ -d signed/ -o $* -f $@ $<

all: $(patsubst zones/%, signed/%, $(wildcard zones/*))


%.checkzone: signed/% FORCE
	named-checkzone $* $<
	grep $* named.conf

check: all $(patsubst zones/%, %.checkzone, $(wildcard zones/*))
	sudo mkdir -p /var/bind
	named-checkconf named.conf

clean:
	rm -rf keys/*.private .key signed/
