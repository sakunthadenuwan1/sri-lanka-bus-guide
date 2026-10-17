import ".styles.global.css";

glob route_names: list[str] = ["01 · Colombo – Kandy", "02 · Colombo – Matara", "EX1 · Makumbura – Matara Expressway", "138 · Colombo – Makumbura", "15 · Colombo – Anuradhapura", "87 · Colombo – Jaffna", "43 · Kandy – Nuwara Eliya"];
glob stops: list[str] = ["Colombo (Pettah)", "Kandy", "Matara", "Galle", "Makumbura (Kottawa)", "Anuradhapura", "Jaffna", "Nuwara Eliya", "Kadawatha", "Nittambuwa", "Kurunegala", "Peradeniya"];
glob bus_services: list[str] = ["Normal", "Semi-Luxury", "A/C Luxury", "Expressway A/C"];

def:pub app() -> JsxElement {
    has active: str = "Timetables",
        from_stop: str = "Colombo (Pettah)",
        to_stop: str = "Kandy",
        service: str = "All services",
        selected_route: str = "01 · Colombo – Kandy",
        departure_date: str = "2026-10-20",
        passenger: str = "",
        notice: str = "",
        username: str = "",
        password: str = "",
        show_login: bool = False,
        login_message: str = "";
    active_style = "bg-primary text-primary-foreground shadow-sm" if active == "Timetables" else "text-muted-foreground hover:bg-muted";
    show_normal = service == "All services" or service == "Normal";
    show_semi = service == "All services" or service == "Semi-Luxury";
    show_ac = service == "All services" or service == "A/C Luxury";
    show_express = service == "All services" or service == "Expressway A/C";

    def choose_from(e: ChangeEvent) { from_stop = e.target.value; }
    def choose_to(e: ChangeEvent) { to_stop = e.target.value; }
    def choose_service(e: ChangeEvent) { service = e.target.value; }
    def choose_route(e: ChangeEvent) { selected_route = e.target.value; }
    def choose_date(e: ChangeEvent) { departure_date = e.target.value; }
    def enter_passenger(e: ChangeEvent) { passenger = e.target.value; }
    def enter_username(e: ChangeEvent) { username = e.target.value; }
    def enter_password(e: ChangeEvent) { password = e.target.value; }
    def switch_to(name: str) { active = name; notice = ""; show_login = False; }
    def submit_login(e: FormEvent) {
        e.preventDefault();
        if username.strip() == "" or password.strip() == "" {
            login_message = "Enter both your username and password.";
        } else {
            login_message = "Demo interface only. Connect an authentication service to sign in securely.";
        }
    }

    return <div className="min-h-screen bg-muted/40 text-foreground">
        <header className="sticky top-0 z-20 border-b bg-card/95 shadow-sm backdrop-blur">
            <div className="mx-auto flex max-w-7xl flex-wrap items-center gap-4 px-4 py-3 sm:px-6">
                <a href="#home" className="flex items-center gap-3 no-underline">
                    <span className="flex size-10 items-center justify-center rounded-xl bg-primary text-lg font-bold text-primary-foreground">G</span>
                    <span><strong className="block text-lg leading-tight tracking-tight">Gamana</strong><small className="text-xs text-muted-foreground">Sri Lanka bus guide</small></span>
                </a>
                <div className="ml-auto flex items-center gap-3">
                    <button className="whitespace-nowrap rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted" onClick={lambda { show_login = not show_login; login_message = ""; }}>Sign in</button>
                </div>
                <nav className="flex w-full gap-1 overflow-x-auto pb-1 sm:ml-auto sm:w-auto" aria-label="Bus guide sections">
                    <button className={"rounded-lg px-3 py-2 text-sm font-medium " + active_style} onClick={lambda { switch_to("Timetables"); }}>Timetables</button>
                    <button className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted" onClick={lambda { switch_to("Fares"); }}>Fares</button>
                    <button className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted" onClick={lambda { switch_to("Trip planner"); }}>Trip planner</button>
                    <button className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted" onClick={lambda { switch_to("Book a seat"); }}>Book a seat</button>
                    <button className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted" onClick={lambda { switch_to("My bookings"); }}>My bookings</button>
                </nav>
            </div>
        </header>
        <main className="mx-auto flex w-full max-w-7xl flex-col gap-6 px-4 py-6 sm:px-6 lg:py-8">
            <section className="relative overflow-hidden rounded-2xl bg-primary px-6 py-8 text-primary-foreground shadow-md sm:px-9 sm:py-10">
                <p className="mb-2 text-sm font-medium text-primary-foreground/80">Travel across Sri Lanka</p>
                <h1 className="text-3xl font-semibold tracking-tight sm:text-4xl">{active}</h1>
                <p className="mt-3 max-w-2xl text-sm leading-relaxed text-primary-foreground/85 sm:text-base">Plan your bus journey with sample schedules, fare estimates and seat reservations in one place.</p>
            </section>
            <div className="flex flex-wrap items-center gap-2 rounded-lg border bg-card px-4 py-3 text-sm text-muted-foreground shadow-sm"><span className="size-2 rounded-full bg-amber-500"></span>Sample information for demonstration. Confirm times and fares with NTC or SLTB before travelling.</div>
            {if show_login {
                <section className="grid min-h-[420px] gap-8 overflow-hidden rounded-2xl border bg-card shadow-sm lg:grid-cols-2">
                    <div className="flex flex-col justify-between gap-10 bg-primary p-7 text-primary-foreground sm:p-10">
                        <div className="flex items-center gap-3"><span className="flex size-10 items-center justify-center rounded-xl bg-primary-foreground/15 text-lg font-bold">G</span><span className="text-lg font-semibold">Gamana</span></div>
                        <div className="flex flex-col gap-4"><p className="text-sm font-medium text-primary-foreground/75">Your journey, made simpler</p><h2 className="text-balance text-3xl font-semibold leading-tight tracking-tight sm:text-4xl">Travel Sri Lanka with confidence.</h2><p className="max-w-md text-sm leading-relaxed text-primary-foreground/80">Keep your trip planning and bus travel information close at hand.</p></div>
                        <p className="text-xs text-primary-foreground/70">Sample travel information. Confirm schedules with your bus operator.</p>
                    </div>
                    <div className="flex items-center justify-center p-6 sm:p-10">
                        <form className="flex w-full max-w-sm flex-col gap-5" onSubmit={submit_login}>
                            <div><h2 className="text-2xl font-semibold tracking-tight">Sign in</h2><p className="mt-1 text-sm text-muted-foreground">Enter your username and password.</p></div>
                            <label className="flex flex-col gap-2 text-sm font-medium">Username<input className="h-11 rounded-md border border-input bg-background px-3 font-normal" autoComplete="username" placeholder="Your username" value={username} onChange={enter_username} /></label>
                            <label className="flex flex-col gap-2 text-sm font-medium">Password<input className="h-11 rounded-md border border-input bg-background px-3 font-normal" type="password" autoComplete="current-password" placeholder="Your password" value={password} onChange={enter_password} /></label>
                            <button className="h-11 rounded-md bg-primary px-4 text-sm font-semibold text-primary-foreground shadow-sm" type="submit">Sign in</button>
                            {if login_message != "" { <p className="rounded-md bg-muted px-3 py-2 text-sm text-muted-foreground" role="status">{login_message}</p> }}
                            <button className="text-sm font-medium text-primary hover:underline" type="button" onClick={lambda { show_login = False; login_message = ""; }}>Return to bus guide</button>
                        </form>
                    </div>
                </section>
            } else {
            <section className="flex flex-col gap-5">
                <div><h2 className="text-xl font-semibold tracking-tight">Find a bus</h2><p className="text-sm text-muted-foreground">Browse service options, departure times and estimated fares.</p></div>
                <div className="grid gap-4 rounded-xl border bg-card p-4 shadow-sm sm:grid-cols-2 lg:grid-cols-4">
                    <label className="flex flex-col gap-2 text-sm font-medium">Route<select className="h-10 rounded-md border border-input bg-background px-3 font-normal" value={selected_route} onChange={choose_route}>{for (i, route) in enumerate(route_names) { <option key={str(i)} value={route}>{route}</option> }}</select></label>
                    <label className="flex flex-col gap-2 text-sm font-medium">From<select className="h-10 rounded-md border border-input bg-background px-3 font-normal" value={from_stop} onChange={choose_from}>{for stop in stops { <option value={stop}>{stop}</option> }}</select></label>
                    <label className="flex flex-col gap-2 text-sm font-medium">To<select className="h-10 rounded-md border border-input bg-background px-3 font-normal" value={to_stop} onChange={choose_to}>{for stop in stops { <option value={stop}>{stop}</option> }}</select></label>
                    <label className="flex flex-col gap-2 text-sm font-medium">Travel date<input className="h-10 rounded-md border border-input bg-background px-3 font-normal" type="date" value={departure_date} onChange={choose_date} /></label>
                    <label className="flex flex-col gap-2 text-sm font-medium sm:col-span-2 lg:col-span-4">Service class<select className="h-10 rounded-md border border-input bg-background px-3 font-normal" value={service} onChange={choose_service}><option>All services</option>{for svc in bus_services { <option value={svc}>{svc}</option> }}</select></label>
                </div>
                <section className="overflow-hidden rounded-xl border bg-card shadow-sm">
                    <div className="flex flex-wrap items-end justify-between gap-3 border-b px-5 py-4"><div><h2 className="text-lg font-semibold">Departures for {from_stop} to {to_stop}</h2><p className="mt-1 text-sm text-muted-foreground">{selected_route} · {departure_date}</p></div><span className="rounded-full bg-primary/10 px-3 py-1 text-xs font-semibold text-primary">Approximate schedule</span></div>
                    <div className="overflow-x-auto"><table className="w-full min-w-[650px] text-left text-sm"><thead className="bg-muted/60 text-xs uppercase tracking-wide text-muted-foreground"><tr><th className="px-5 py-3">Departure</th><th className="px-5 py-3">Arrival</th><th className="px-5 py-3">Service</th><th className="px-5 py-3">Duration</th><th className="px-5 py-3">Estimated fare</th></tr></thead><tbody>{if show_normal { <tr className="border-t"><td className="px-5 py-4 font-semibold tabular-nums">05:00</td><td className="px-5 py-4 tabular-nums">08:30</td><td className="px-5 py-4">Normal</td><td className="px-5 py-4">3h 30m</td><td className="px-5 py-4 font-medium">Rs. 350</td></tr> }}{if show_semi { <tr className="border-t"><td className="px-5 py-4 font-semibold tabular-nums">06:00</td><td className="px-5 py-4 tabular-nums">09:30</td><td className="px-5 py-4">Semi-Luxury</td><td className="px-5 py-4">3h 30m</td><td className="px-5 py-4 font-medium">Rs. 525</td></tr> }}{if show_ac { <tr className="border-t"><td className="px-5 py-4 font-semibold tabular-nums">07:00</td><td className="px-5 py-4 tabular-nums">10:15</td><td className="px-5 py-4">A/C Luxury</td><td className="px-5 py-4">3h 15m</td><td className="px-5 py-4 font-medium">Rs. 700</td></tr> }}{if show_express { <tr className="border-t"><td className="px-5 py-4 font-semibold tabular-nums">08:00</td><td className="px-5 py-4 tabular-nums">10:00</td><td className="px-5 py-4">Expressway A/C</td><td className="px-5 py-4">2h 00m</td><td className="px-5 py-4 font-medium">Rs. 1,020</td></tr> }}</tbody></table></div>
                </section>
                <div className="grid gap-4 sm:grid-cols-3"><article className="rounded-xl border bg-card p-5 shadow-sm"><p className="text-sm text-muted-foreground">Route distance</p><p className="mt-2 text-2xl font-semibold tabular-nums">116 km</p><p className="mt-1 text-xs text-muted-foreground">Colombo to Kandy</p></article><article className="rounded-xl border bg-card p-5 shadow-sm"><p className="text-sm text-muted-foreground">First bus</p><p className="mt-2 text-2xl font-semibold tabular-nums">04:30</p><p className="mt-1 text-xs text-muted-foreground">Daily sample schedule</p></article><article className="rounded-xl border bg-card p-5 shadow-sm"><p className="text-sm text-muted-foreground">Service options</p><p className="mt-2 text-2xl font-semibold tabular-nums">3</p><p className="mt-1 text-xs text-muted-foreground">Normal, semi-luxury and A/C</p></article></div>
                <div className="grid gap-4 sm:grid-cols-2"><article className="rounded-xl border bg-card p-5 shadow-sm"><h2 className="text-lg font-semibold">Popular routes</h2>{for route in route_names { <p className="border-b py-3 text-sm last:border-0">{route}</p> }}</article><article className="rounded-xl border bg-card p-5 shadow-sm"><h2 className="text-lg font-semibold">Plan your next ride</h2><p className="mt-2 text-sm text-muted-foreground">Explore fare estimates, plan a journey, or reserve a sample seat.</p><button className="mt-4 rounded-md bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground" onClick={lambda { switch_to("Trip planner"); }}>Open trip planner</button></article></div>
                {if notice != "" { <p className="rounded-lg bg-primary/10 p-3 text-sm text-primary" role="status">{notice}</p> }}
            </section>
            }}
            <footer className="border-t pt-5 text-center text-xs text-muted-foreground">Gamana · Sri Lanka bus timetables, fares and bookings</footer>
        </main>
    </div>;
}
