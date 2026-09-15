//! Provider-neutral ML-KEM parameter sets used by the backend facade.

pub const ParameterSet = enum {
    mlkem768,
    mlkem1024,

    pub fn publicKeyLen(self: ParameterSet) u16 {
        return switch (self) {
            .mlkem768 => 1184,
            .mlkem1024 => 1568,
        };
    }

    pub fn ciphertextLen(self: ParameterSet) u16 {
        return switch (self) {
            .mlkem768 => 1088,
            .mlkem1024 => 1568,
        };
    }

    pub fn sharedSecretLen(_: ParameterSet) u8 {
        return 32;
    }
};
