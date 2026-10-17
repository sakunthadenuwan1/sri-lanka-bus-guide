import ".styles.global.css";
import from "@jac/runtime" { jacLogin, jacSignup, jacLogout, jacIsLoggedIn }

glob destinations: list[str] = ["Colombo (Pettah)", "Kandy", "Matara", "Galle", "Makumbura (Kottawa)", "Anuradhapura", "Jaffna", "Nuwara Eliya", "Kadawatha", "Nittambuwa", "Kurunegala", "Peradeniya"];
glob route_names: list[str] = ["01 · Colombo – Kandy", "02 · Colombo – Matara", "EX1 · Makumbura – Matara Expressway", "138 · Colombo – Makumbura", "15 · Colombo – Anuradhapura", "87 · Colombo – Jaffna", "43 · Kandy – Nuwara Eliya"];
glob service_names: list[str] = ["Normal", "Semi-Luxury", "A/C Luxury", "Expressway A/C"];

def:pub app() -> JsxElement {
    has authenticated: bool = False,
        active: str = "Home",
        show_login: bool = False,
        registering: bool = False,
        auth_busy: bool = False,
        username: str = "",
        password: str = "",
        auth_message: str = "",
        origin: str = "Colombo (Pettah)",
        destination: str = "Kandy",
        travel_date: str = "2026-10-20",
        service: str = "All services",
        passenger: str = "",
        seat: int = 0,
        saved_bookings: list[str] = [],
        notice: str = "",
        confirm_logout: bool = False;

    async can with entry { authenticated = jacIsLoggedIn(); }
    def set_origin(e: ChangeEvent) { origin = e.target.value; }
    def set_destination(e: ChangeEvent) { destination = e.target.value; }
    def set_date(e: ChangeEvent) { travel_date = e.target.value; }
    def set_service(e: ChangeEvent) { service = e.target.value; }
    def set_passenger(e: ChangeEvent) { passenger = e.target.value; }
    def set_username(e: ChangeEvent) { username = e.target.value; }
    def set_password(e: ChangeEvent) { password = e.target.value; }
    def set_seat(n: int) { seat = n; }
    def confirm_booking(e: FormEvent) {
        e.preventDefault();
        if passenger.strip() == "" { notice = "Enter your name before booking."; }
        elif seat == 0 { notice = "Select a seat before booking."; }
        else { saved_bookings = saved_bookings + [origin + " to " + destination + " · Seat " + str(seat) + " · " + passenger.strip() + " · " + travel_date]; notice = "Booking saved."; active = "My bookings"; seat = 0; passenger = ""; }
    }

    def navigate_to(view: str) {
        if not authenticated { show_login = True; registering = False; auth_message = "Sign in to access travel tools."; }
        else { active = view; notice = ""; }
    }

    def search_trips(e: FormEvent) {
        e.preventDefault();
        if origin == destination { notice = "Choose two different towns."; }
        elif not authenticated { show_login = True; registering = False; auth_message = "Sign in to view schedules for this journey."; }
        else { active = "Timetables"; }
    }

    async def submit_auth(e: FormEvent) {
        e.preventDefault();
        auth_message = "";
        if username.strip() == "" or password.strip() == "" { auth_message = "Enter a username and password."; }
        else {
            auth_busy = True;
            if registering {
                signup_response: dict | None = None;
                signup_response = await jacSignup(username.strip(), password);
                if not signup_response["success"] { auth_message = "Could not create account. Check the details or try another username."; }
                else {
                    login_result: bool = False;
                    login_result = await jacLogin(username.strip(), password);
                    if login_result { authenticated = True; show_login = False; active = "Timetables"; }
                    else { registering = False; auth_message = "Account created. Sign in with your new credentials."; }
                }
            } else {
                signed_in: bool = False;
                signed_in = await jacLogin(username.strip(), password);
                if signed_in { authenticated = True; show_login = False; active = "Timetables"; }
                else { auth_message = "Sign-in failed. Check your username and password."; }
            }
            auth_busy = False;
        }
    }

    def do_logout(e: MouseEvent) { confirm_logout = True; }
    def cancel_logout(e: MouseEvent) { confirm_logout = False; }
    def finish_logout(e: MouseEvent) {
        jacLogout();
        authenticated = False;
        confirm_logout = False;
        show_login = False;
        active = "Home";
        username = "";
        password = "";
    }

    if show_login and not authenticated {
        return <div className="min-h-screen bg-[#080808] px-4 py-8 text-white sm:px-8">
            <div className="mx-auto grid min-h-[80vh] max-w-5xl overflow-hidden rounded-3xl border border-white/10 bg-zinc-950 shadow-2xl md:grid-cols-2">
                <section className="flex flex-col justify-between gap-10 bg-gradient-to-br from-red-950 to-black p-8 sm:p-12"><button className="flex items-center gap-3 self-start" onClick={lambda { show_login = False; active = "Home"; }}><span className="flex size-10 items-center justify-center rounded-xl bg-red-600 font-bold">G</span><span className="font-semibold">Gamana</span></button><div><p className="text-sm font-semibold uppercase tracking-widest text-red-300">Sri Lanka bus guide</p><h1 className="mt-4 text-4xl font-black leading-tight">Travel Sri Lanka on time.</h1><p className="mt-4 text-zinc-300">Sign in to access schedules, fare estimates, trip planning and seat bookings.</p></div><p className="text-xs text-zinc-400">Sample travel information. Confirm details with operators.</p></section>
                <section className="flex items-center p-7 sm:p-12"><form className="flex w-full flex-col gap-5" onSubmit={submit_auth}><div><h2 className="text-2xl font-bold">{"Create your account" if registering else "Welcome back"}</h2><p className="mt-1 text-sm text-zinc-400">{"Register with a username and password." if registering else "Sign in to continue to your travel tools."}</p></div><label className="flex flex-col gap-2 text-sm font-medium">Username<input className="h-11 rounded-lg border border-white/10 bg-black px-3 text-white" placeholder="Your username" autoComplete="username" value={username} onChange={set_username} /></label><label className="flex flex-col gap-2 text-sm font-medium">Password<input className="h-11 rounded-lg border border-white/10 bg-black px-3 text-white" type="password" placeholder="Your password" autoComplete="current-password" value={password} onChange={set_password} /></label><button className="h-11 rounded-lg bg-red-600 font-bold hover:bg-red-500" disabled={auth_busy} type="submit">{"Please wait..." if auth_busy else "Create account" if registering else "Sign in"}</button>{auth_message != "" and <p className="rounded-lg bg-white/5 p-3 text-sm text-zinc-300" role="status">{auth_message}</p>}<button className="text-left text-sm text-red-300 hover:underline" type="button" onClick={lambda { registering = not registering; auth_message = ""; }}>{"Already have an account? Sign in" if registering else "New to Gamana? Create an account"}</button></form></section>
            </div>
        </div>;
    }

    if active == "Home" {
        return <div className="min-h-screen bg-[#080808] text-white">
            <header className="mx-auto flex max-w-7xl flex-wrap items-center gap-4 px-4 py-4 sm:px-6"><button className="flex items-center gap-3" onClick={lambda { active = "Home"; }}><span className="flex size-10 items-center justify-center rounded-xl bg-red-600 text-lg font-bold">G</span><span><strong className="block text-lg">Gamana</strong><small className="text-xs text-zinc-400">Sri Lanka bus guide</small></span></button><div className="ml-auto flex gap-2"><button className="rounded-lg border border-white/15 px-4 py-2 text-sm text-zinc-300 hover:bg-white/5" onClick={lambda { show_login = True; registering = False; auth_message = ""; }}>Sign in</button><button className="rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold hover:bg-red-500" onClick={lambda { show_login = True; registering = True; auth_message = ""; }}>Create account</button></div></header>
            <main className="mx-auto flex max-w-7xl flex-col gap-10 px-4 pb-12 sm:px-6">
                <section className="relative overflow-hidden rounded-3xl border border-white/10 bg-black px-5 py-12 sm:px-10 sm:py-16 lg:px-16"><div className="pointer-events-none absolute inset-0 bg-[radial-gradient(50%_50%_at_88%_10%,rgba(220,0,24,0.28),transparent)]"></div><div className="pointer-events-none absolute inset-0 opacity-20 [background-image:linear-gradient(rgba(255,255,255,0.05)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.05)_1px,transparent_1px)] [background-size:72px_72px]"></div><div className="relative mx-auto flex max-w-5xl flex-col items-center gap-7 text-center"><p className="text-xs font-bold uppercase tracking-[0.24em] text-zinc-400"><span className="mr-2 inline-block size-2 rounded-full bg-red-600"></span>Bus travel across Sri Lanka</p><h1 className="text-balance text-5xl font-black leading-[0.98] tracking-tight sm:text-6xl lg:text-8xl">Travel Sri Lanka<br/><span className="text-red-600">on time.</span></h1><p className="max-w-2xl text-base leading-relaxed text-zinc-400 sm:text-xl">Check schedules, compare fares, choose your seat and plan your bus journey in one place.</p><form className="mt-3 grid w-full gap-3 rounded-2xl border border-white/10 bg-zinc-900/90 p-3 text-left shadow-2xl sm:grid-cols-2 sm:p-4 lg:grid-cols-[1fr_1fr_0.8fr_auto]" onSubmit={search_trips}><label className="flex flex-col gap-2 px-2 text-[11px] font-bold uppercase tracking-[0.16em] text-zinc-500">From<select className="h-11 rounded-lg border border-white/10 bg-zinc-950 px-3 text-sm font-semibold normal-case tracking-normal text-white" value={origin} onChange={set_origin}>{for (i, stop) in enumerate(destinations) { <option key={str(i)} value={stop}>{stop}</option> }}</select></label><label className="flex flex-col gap-2 px-2 text-[11px] font-bold uppercase tracking-[0.16em] text-zinc-500">Destination<select className="h-11 rounded-lg border border-white/10 bg-zinc-950 px-3 text-sm font-semibold normal-case tracking-normal text-white" value={destination} onChange={set_destination}>{for (i, stop) in enumerate(destinations) { <option key={str(i)} value={stop}>{stop}</option> }}</select></label><label className="flex flex-col gap-2 px-2 text-[11px] font-bold uppercase tracking-[0.16em] text-zinc-500">Travel date<input className="h-11 rounded-lg border border-white/10 bg-zinc-950 px-3 text-sm font-semibold normal-case tracking-normal text-white" type="date" value={travel_date} onChange={set_date} /></label><button className="min-h-11 self-end rounded-xl bg-red-600 px-6 py-3 text-sm font-bold text-white shadow-lg shadow-red-950/50 hover:bg-red-500" type="submit">Search buses</button></form><div className="flex flex-wrap items-center justify-center gap-2 text-sm text-zinc-500"><span className="px-2">Popular:</span><button type="button" className="rounded-full border border-white/10 bg-white/5 px-4 py-2 text-zinc-300 hover:border-red-700" onClick={lambda { origin = "Colombo (Pettah)"; destination = "Kandy"; }}>Colombo to Kandy</button><button type="button" className="rounded-full border border-white/10 bg-white/5 px-4 py-2 text-zinc-300 hover:border-red-700" onClick={lambda { origin = "Colombo (Pettah)"; destination = "Galle"; }}>Colombo to Galle</button><button type="button" className="rounded-full border border-white/10 bg-white/5 px-4 py-2 text-zinc-300 hover:border-red-700" onClick={lambda { origin = "Colombo (Pettah)"; destination = "Jaffna"; }}>Colombo to Jaffna</button><button type="button" className="rounded-full border border-white/10 bg-white/5 px-4 py-2 text-zinc-300 hover:border-red-700" onClick={lambda { origin = "Kandy"; destination = "Nuwara Eliya"; }}>Kandy to Nuwara Eliya</button></div>{notice != "" and <p className="text-sm text-red-300" role="alert">{notice}</p>}</div></section>
                <section className="grid gap-4 sm:grid-cols-3"><article className="rounded-2xl border border-white/10 bg-zinc-950 p-5"><p className="text-sm text-zinc-400">Plan ahead</p><h2 className="mt-2 text-lg font-semibold">Timetables that fit your day</h2><p className="mt-1 text-sm text-zinc-500">See sample departures for popular routes.</p></article><article className="rounded-2xl border border-white/10 bg-zinc-950 p-5"><p className="text-sm text-zinc-400">Know the cost</p><h2 className="mt-2 text-lg font-semibold">Compare estimated fares</h2><p className="mt-1 text-sm text-zinc-500">Choose a service class before you go.</p></article><article className="rounded-2xl border border-white/10 bg-zinc-950 p-5"><p className="text-sm text-zinc-400">Ride with confidence</p><h2 className="mt-2 text-lg font-semibold">Reserve a sample seat</h2><p className="mt-1 text-sm text-zinc-500">Sign in to access seat booking and saved trips.</p></article></section>
            </main>
        </div>;
    }

    if not authenticated {
        return <div className="min-h-screen bg-background p-6"><section className="mx-auto flex max-w-xl flex-col gap-4 rounded-2xl border bg-card p-8 text-center shadow-sm"><h1 className="text-2xl font-semibold">Sign in to continue</h1><p className="text-sm text-muted-foreground">Internal schedules, fares and booking tools are available after sign-in.</p><button className="rounded-lg bg-primary px-5 py-3 font-semibold text-primary-foreground" onClick={lambda { show_login = True; registering = False; auth_message = ""; }}>Sign in</button><button className="text-sm text-primary hover:underline" onClick={lambda { active = "Home"; }}>Back to home</button></section></div>;
    }

    fare_amount = int(116 * 6) if service == "A/C Luxury" else int(116 * 4.5) if service == "Semi-Luxury" else int(116 * 3);
    return <div className="min-h-screen bg-[#080808] text-zinc-100">
        <header className="sticky top-0 z-20 border-b border-white/10 bg-[#090909]/95 shadow-lg backdrop-blur"><div className="mx-auto flex max-w-7xl flex-wrap items-center gap-3 px-4 py-3 sm:px-6"><button className="flex items-center gap-3" onClick={lambda { active = "Home"; }}><span className="flex size-10 items-center justify-center rounded-xl bg-red-600 font-bold text-white">G</span><span><strong className="block text-zinc-100">Gamana</strong><small className="text-xs text-zinc-400">Signed in as {username}</small></span></button><nav className="ml-auto flex gap-1 overflow-x-auto">{for (i, page) in enumerate(["Timetables", "Fares", "Trip planner", "Book a seat", "My bookings"]) { <button key={str(i)} className="whitespace-nowrap rounded-lg px-3 py-2 text-sm hover:bg-muted" onClick={lambda { navigate_to(page); }}>{page}</button> }}</nav><button className="rounded-lg border border-white/15 px-3 py-2 text-sm text-zinc-200 hover:border-red-600 hover:text-white" onClick={do_logout}>Log out</button>{confirm_logout and <button className="rounded-lg bg-destructive px-3 py-2 text-sm text-destructive-foreground" onClick={finish_logout}>Confirm logout</button>}</div></header>
        <main className="mx-auto flex max-w-7xl flex-col gap-5 px-4 py-6 sm:px-6"><h1 className="text-3xl font-bold text-white">{active}</h1>
        {if active == "Fares" { <section className="rounded-2xl border border-white/10 bg-zinc-950 p-6 shadow-sm"><h2 className="text-xl font-semibold">Fare estimate</h2><div className="mt-4 grid gap-4 sm:grid-cols-3"><label className="flex flex-col gap-2 text-sm">From<select className="rounded-lg border border-white/10 bg-black p-3 text-white" value={origin} onChange={set_origin}>{for (i, stop) in enumerate(destinations) { <option key={str(i)} value={stop}>{stop}</option> }}</select></label><label className="flex flex-col gap-2 text-sm">To<select className="rounded-lg border border-white/10 bg-black p-3 text-white" value={destination} onChange={set_destination}>{for (i, stop) in enumerate(destinations) { <option key={str(i)} value={stop}>{stop}</option> }}</select></label><label className="flex flex-col gap-2 text-sm">Service<select className="rounded-lg border border-white/10 bg-black p-3 text-white" value={service} onChange={set_service}>{for (i, item) in enumerate(service_names) { <option key={str(i)} value={item}>{item}</option> }}</select></label></div><p className="mt-5 text-3xl font-bold">Estimated fare: Rs. {str(fare_amount)}</p></section> }}
        {if active == "Trip planner" { <section className="rounded-2xl border border-white/10 bg-zinc-950 p-6 shadow-sm"><h2 className="text-xl font-semibold">Suggested trip</h2><p className="mt-3">{origin} to {destination}</p><p className="mt-2 text-sm text-muted-foreground">Direct sample service · depart 05:00 · arrive 08:30 · {travel_date}</p></section> }}
        {if active == "Book a seat" { <section className="grid gap-5 lg:grid-cols-2"><form className="flex flex-col gap-4 rounded-2xl border bg-card p-6 shadow-sm" onSubmit={confirm_booking}><h2 className="text-xl font-semibold">Reserve a seat</h2><label className="flex flex-col gap-2 text-sm">Passenger name<input className="rounded-lg border border-white/10 bg-black p-3 text-white" value={passenger} onChange={set_passenger} placeholder="Your full name" /></label><p>Trip: {origin} to {destination} · {travel_date}</p><p>Selected seat: {str(seat) if seat > 0 else "None"}</p><button type="submit" className="rounded-lg bg-red-600 px-4 py-3 font-semibold text-white hover:bg-red-500">Confirm booking</button>{notice != "" and <p role="status" className="text-sm text-primary">{notice}</p>}</form><div className="grid grid-cols-4 gap-3 rounded-2xl border bg-card p-6">{for n in range(1, 17) { <button key={str(n)} type="button" className="aspect-square rounded-lg border border-white/10 bg-black text-zinc-100 hover:border-red-600 hover:bg-red-950/30" onClick={lambda { set_seat(n); }}>{str(n)}</button> }}</div></section> }}
        {if active == "My bookings" { <section className="rounded-2xl border border-white/10 bg-zinc-950 p-6 shadow-sm"><h2 className="text-xl font-semibold">Saved bookings</h2>{if len(saved_bookings) == 0 { <p className="mt-4 text-sm text-muted-foreground">No bookings yet.</p> }}{for (i, booking) in enumerate(saved_bookings) { <p key={str(i)} className="mt-3 rounded-lg border border-white/10 bg-black p-4 text-sm text-zinc-200">{booking}</p> }}</section> }}
        {if active == "Timetables" { <section className="rounded-2xl border border-white/10 bg-zinc-950 p-6 shadow-sm"><h2 className="text-xl font-semibold">Bus timetable</h2><p className="mt-2">{origin} to {destination} · {travel_date}</p><div className="mt-4 grid gap-3 sm:grid-cols-3"><p className="rounded-lg border p-4">05:00 · Normal · Rs. 350</p><p className="rounded-lg border p-4">06:00 · Semi-Luxury · Rs. 525</p><p className="rounded-lg border p-4">07:00 · A/C Luxury · Rs. 700</p></div></section> }}</main></div>;
}
