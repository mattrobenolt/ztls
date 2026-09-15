comptime {
    @compileError(
        "ztls_xev is opt-in; pass .xev = true to b.dependency(\"ztls\", ...)",
    );
}
