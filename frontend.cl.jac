"""The build splash — what the preview shows before the app exists.

Two states:

  * No prompt (created from the template gallery) -> the sparkles message.
  * With a prompt -> the JacBuilder splash: the user's own words echoed back,
    plus a wireframe skeleton of the KIND of app they asked for.

`BUILD_PROMPT` is a sentinel the IDE rewrites at create time
(`project_manager._apply_build_prompt_to_template`). It finds this file by
name and that string by value -- do not rename either.

The skeleton is a guess keyed off words in the prompt. That is deliberate: a
shimmer reads as "loading", never as a promise, so a rough shape costs
nothing when it is wrong and orients the user when it is right. Prompts that
match nothing fall back to a neutral app shell.

The whole splash disappears the moment JacCoder rewrites this file. Keep it
that way -- a skeleton that outlives the real UI is worse than no skeleton.

Two client-Jac constraints shaped this file, both worth knowing before you
edit it:
  * `.map(...)` over a literal list trips the checker ("list has no attribute
    map"), so repeated bars are written out longhand.
  * Use Python string methods (`.lower()`, `x in y`), not the JS ones --
    `.toLowerCase()` / `.indexOf()` do not type-check.
"""

cl import ".styles.global.css";
cl import from ".components.ui.skeleton" { Skeleton }

glob BUILD_PROMPT: str = "<!doctype html> <html lang=\"en\"> <head>   <meta charset=\"utf-8\">   <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">   <title>Gamana – Sri Lanka Bus Guide</title>   <meta name=\"description\" content=\"Bus timetables, fares, trip planning and seat booking for Sri Lankan bus routes.\">   <meta name=\"theme-color\" content=\"#7a1626\">   <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">   <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>   <link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap\">   <link rel=\"stylesheet\" href=\"css/styles.css\"> </head> <body>   <header class=\"topbar\">     <div class=\"wrap topbar-inner\">       <a class=\"brand\" href=\"#timetable\" aria-label=\"Gamana home\">         <svg class=\"brand-mark\" viewBox=\"0 0 24 24\" aria-hidden=\"true\">           <path d=\"M5 3h14a2 2 0 0 1 2 2v11a2 2 0 0 1-1 1.73V20a1 1 0 0 1-1 1h-1a1 1 0 0 1-1-1v-2H7v2a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-2.27A2 2 0 0 1 3 16V5a2 2 0 0 1 2-2Zm0 3v5h14V6H5Zm2 7.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Zm10 0a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z\"/>         </svg>         <span>Gamana<small>Sri Lanka bus guide</small></span>       </a>       <nav class=\"tabs\" id=\"tabs\" aria-label=\"Sections\">         <span class=\"tab-indicator\" id=\"tabIndicator\" aria-hidden=\"true\"></span>         <a href=\"#timetable\" data-view=\"timetable\">Timetables</a>         <a href=\"#fares\" data-view=\"fares\">Fares</a>         <a href=\"#planner\" data-view=\"planner\">Trip planner</a>         <a href=\"#book\" data-view=\"book\">Book a seat</a>         <a href=\"#bookings\" data-view=\"bookings\">My bookings <span class=\"count\" id=\"bookingCount\" hidden></span></a>       </nav>     </div>   </header>    <p class=\"notice wrap\">Sample data for demonstration. Confirm times and fares with NTC / SLTB before you travel.</p>    <main class=\"wrap\">     <section id=\"view-timetable\" class=\"view\" hidden></section>     <section id=\"view-fares";

# The preview iframe cannot see the IDE's theme, so the sandbox proxy stamps it
# on a `preview_theme` cookie at /__auth. Applied during render, not from an
# effect -- an effect runs after the first paint and the splash flashes white.
cl def _applyPreviewTheme() -> None {
    isDark = False;
    for part in document.cookie.split(";") {
        if part.strip() == "preview_theme=dark" {
            isDark = True;
        }
    }
    if isDark {
        document.documentElement.classList.add("dark");
    }
}

# keyword -> layout, first match wins.
glob _HINTS: list[list[str]] = [
    ["dashboard", "dashboard"], ["admin", "dashboard"], ["analytics", "dashboard"],
    ["metrics", "dashboard"], ["chart", "dashboard"], ["crm", "dashboard"],
    ["tracker", "dashboard"], ["report", "dashboard"],
    ["landing", "landing"], ["marketing", "landing"], ["waitlist", "landing"],
    ["saas", "landing"], ["homepage", "landing"], ["portfolio", "landing"],
    ["pricing", "landing"],
    ["chat", "chat"], ["assistant", "chat"], ["messaging", "chat"],
    ["inbox", "chat"], ["bot", "chat"],
    ["shop", "shop"], ["store", "shop"], ["ecommerce", "shop"],
    ["commerce", "shop"], ["product", "shop"], ["cart", "shop"],
    ["blog", "blog"], ["docs", "blog"], ["article", "blog"],
    ["news", "blog"], ["documentation", "blog"]
];

glob _PANEL: str = "rounded-xl border border-border bg-card";


cl def:pub DashboardSkeleton() -> JsxElement {
    return <div className="flex w-full gap-4">
        <div className={"hidden md:flex w-44 shrink-0 flex-col gap-3 self-stretch pt-5 pb-5 pl-4 pr-4 " + _PANEL}>
            <Skeleton className="h-5 w-24" />
            <Skeleton className="h-3.5 w-full" />
            <Skeleton className="h-3.5 w-full" />
            <Skeleton className="h-3.5 w-full" />
            <Skeleton className="h-3.5 w-2/3" />
        </div>
        <div className="flex flex-1 flex-col gap-4">
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
                <div className={"flex flex-col gap-3 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                    <Skeleton className="h-3 w-16" />
                    <Skeleton className="h-7 w-14" />
                </div>
                <div className={"flex flex-col gap-3 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                    <Skeleton className="h-3 w-16" />
                    <Skeleton className="h-7 w-14" />
                </div>
                <div className={"flex flex-col gap-3 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                    <Skeleton className="h-3 w-16" />
                    <Skeleton className="h-7 w-14" />
                </div>
            </div>
            <div className={"flex h-56 items-end gap-2 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                <Skeleton className="h-2/5 flex-1" />
                <Skeleton className="h-3/4 flex-1" />
                <Skeleton className="h-1/2 flex-1" />
                <Skeleton className="h-5/6 flex-1" />
                <Skeleton className="h-1/3 flex-1" />
                <Skeleton className="h-2/3 flex-1" />
                <Skeleton className="h-3/4 flex-1" />
            </div>
            <div className={"flex flex-col gap-3 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                <div className="flex items-center gap-4">
                    <Skeleton className="h-3.5 w-32" />
                    <Skeleton className="ml-auto h-3.5 w-20" />
                    <Skeleton className="h-3.5 w-16" />
                </div>
                <div className="flex items-center gap-4">
                    <Skeleton className="h-3.5 w-40" />
                    <Skeleton className="ml-auto h-3.5 w-20" />
                    <Skeleton className="h-3.5 w-16" />
                </div>
                <div className="flex items-center gap-4">
                    <Skeleton className="h-3.5 w-28" />
                    <Skeleton className="ml-auto h-3.5 w-20" />
                    <Skeleton className="h-3.5 w-16" />
                </div>
                <div className="flex items-center gap-4">
                    <Skeleton className="h-3.5 w-36" />
                    <Skeleton className="ml-auto h-3.5 w-20" />
                    <Skeleton className="h-3.5 w-16" />
                </div>
                <div className="flex items-center gap-4">
                    <Skeleton className="h-3.5 w-24" />
                    <Skeleton className="ml-auto h-3.5 w-20" />
                    <Skeleton className="h-3.5 w-16" />
                </div>
            </div>
        </div>
    </div>;
}


cl def:pub LandingSkeleton() -> JsxElement {
    return <div className="flex w-full flex-col gap-5">
        <div className={"flex items-center gap-4 pt-3 pb-3 pl-4 pr-4 " + _PANEL}>
            <Skeleton className="h-5 w-24" />
            <div className="ml-auto flex gap-3">
                <Skeleton className="h-3.5 w-14" />
                <Skeleton className="h-3.5 w-14" />
                <Skeleton className="h-3.5 w-14" />
            </div>
        </div>
        <div className="flex flex-col items-center gap-4 pt-8 pb-8">
            <Skeleton className="h-9 w-3/4 max-w-lg" />
            <Skeleton className="h-9 w-1/2 max-w-sm" />
            <Skeleton className="mt-2 h-4 w-2/3 max-w-md" />
            <div className="mt-3 flex gap-3">
                <Skeleton className="h-10 w-32 rounded-lg bg-primary/25" />
                <Skeleton className="h-10 w-28 rounded-lg" />
            </div>
        </div>
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
            <div className={"flex flex-col gap-3 pt-5 pb-5 pl-4 pr-4 " + _PANEL}>
                <Skeleton className="size-9 rounded-lg bg-primary/20" />
                <Skeleton className="h-4 w-24" />
                <Skeleton className="h-3 w-full" />
            </div>
            <div className={"flex flex-col gap-3 pt-5 pb-5 pl-4 pr-4 " + _PANEL}>
                <Skeleton className="size-9 rounded-lg bg-primary/20" />
                <Skeleton className="h-4 w-24" />
                <Skeleton className="h-3 w-full" />
            </div>
            <div className={"flex flex-col gap-3 pt-5 pb-5 pl-4 pr-4 " + _PANEL}>
                <Skeleton className="size-9 rounded-lg bg-primary/20" />
                <Skeleton className="h-4 w-24" />
                <Skeleton className="h-3 w-full" />
            </div>
        </div>
    </div>;
}


cl def:pub ChatSkeleton() -> JsxElement {
    return <div className={"flex w-full flex-col gap-4 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
        <div className="flex items-center gap-3">
            <Skeleton className="size-9 rounded-full" />
            <Skeleton className="h-4 w-28" />
        </div>
        <div className="flex flex-col gap-3">
            <Skeleton className="h-12 w-3/5 rounded-2xl" />
            <Skeleton className="h-14 w-2/3 self-end rounded-2xl bg-primary/20" />
            <Skeleton className="h-16 w-3/4 rounded-2xl" />
            <Skeleton className="h-10 w-1/2 self-end rounded-2xl bg-primary/20" />
        </div>
        <div className={"mt-auto flex items-center gap-3 pt-3 pb-3 pl-4 pr-4 " + _PANEL}>
            <Skeleton className="h-4 flex-1" />
            <Skeleton className="size-8 rounded-lg bg-primary/25" />
        </div>
    </div>;
}


cl def:pub ShopSkeleton() -> JsxElement {
    return <div className="flex w-full flex-col gap-5">
        <div className={"flex items-center gap-4 pt-3 pb-3 pl-4 pr-4 " + _PANEL}>
            <Skeleton className="h-5 w-20" />
            <Skeleton className="ml-auto h-8 w-40 rounded-lg" />
        </div>
        <div className="grid grid-cols-2 gap-4 lg:grid-cols-3">
            <div className={"flex flex-col gap-3 pt-3 pb-3 pl-3 pr-3 " + _PANEL}>
                <Skeleton className="h-24 w-full" />
                <Skeleton className="h-3.5 w-3/4" />
                <Skeleton className="h-3.5 w-1/3" />
            </div>
            <div className={"flex flex-col gap-3 pt-3 pb-3 pl-3 pr-3 " + _PANEL}>
                <Skeleton className="h-24 w-full" />
                <Skeleton className="h-3.5 w-3/4" />
                <Skeleton className="h-3.5 w-1/3" />
            </div>
            <div className={"flex flex-col gap-3 pt-3 pb-3 pl-3 pr-3 " + _PANEL}>
                <Skeleton className="h-24 w-full" />
                <Skeleton className="h-3.5 w-3/4" />
                <Skeleton className="h-3.5 w-1/3" />
            </div>
            <div className={"flex flex-col gap-3 pt-3 pb-3 pl-3 pr-3 " + _PANEL}>
                <Skeleton className="h-24 w-full" />
                <Skeleton className="h-3.5 w-3/4" />
                <Skeleton className="h-3.5 w-1/3" />
            </div>
            <div className={"flex flex-col gap-3 pt-3 pb-3 pl-3 pr-3 " + _PANEL}>
                <Skeleton className="h-24 w-full" />
                <Skeleton className="h-3.5 w-3/4" />
                <Skeleton className="h-3.5 w-1/3" />
            </div>
            <div className={"flex flex-col gap-3 pt-3 pb-3 pl-3 pr-3 " + _PANEL}>
                <Skeleton className="h-24 w-full" />
                <Skeleton className="h-3.5 w-3/4" />
                <Skeleton className="h-3.5 w-1/3" />
            </div>
        </div>
    </div>;
}


cl def:pub BlogSkeleton() -> JsxElement {
    return <div className="flex w-full gap-5">
        <div className="flex flex-1 flex-col gap-4">
            <div className={"flex gap-4 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                <Skeleton className="size-16 shrink-0" />
                <div className="flex flex-1 flex-col gap-2.5">
                    <Skeleton className="h-4 w-2/3" />
                    <Skeleton className="h-3 w-full" />
                    <Skeleton className="h-3 w-1/2" />
                </div>
            </div>
            <div className={"flex gap-4 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                <Skeleton className="size-16 shrink-0" />
                <div className="flex flex-1 flex-col gap-2.5">
                    <Skeleton className="h-4 w-2/3" />
                    <Skeleton className="h-3 w-full" />
                    <Skeleton className="h-3 w-1/2" />
                </div>
            </div>
            <div className={"flex gap-4 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                <Skeleton className="size-16 shrink-0" />
                <div className="flex flex-1 flex-col gap-2.5">
                    <Skeleton className="h-4 w-2/3" />
                    <Skeleton className="h-3 w-full" />
                    <Skeleton className="h-3 w-1/2" />
                </div>
            </div>
            <div className={"flex gap-4 pt-4 pb-4 pl-4 pr-4 " + _PANEL}>
                <Skeleton className="size-16 shrink-0" />
                <div className="flex flex-1 flex-col gap-2.5">
                    <Skeleton className="h-4 w-2/3" />
                    <Skeleton className="h-3 w-full" />
                    <Skeleton className="h-3 w-1/2" />
                </div>
            </div>
        </div>
        <div className={"hidden lg:flex w-52 shrink-0 flex-col gap-3 pt-5 pb-5 pl-4 pr-4 " + _PANEL}>
            <Skeleton className="h-4 w-24" />
            <Skeleton className="h-3 w-full" />
            <Skeleton className="h-3 w-full" />
            <Skeleton className="h-3 w-full" />
            <Skeleton className="h-3 w-2/3" />
        </div>
    </div>;
}


cl def:pub AppSkeleton() -> JsxElement {
    return <div className="flex w-full flex-col gap-5">
        <div className={"flex items-center gap-4 pt-3 pb-3 pl-4 pr-4 " + _PANEL}>
            <Skeleton className="size-7 rounded-lg bg-primary/25" />
            <Skeleton className="h-4 w-28" />
            <Skeleton className="ml-auto size-8 rounded-full" />
        </div>
        <div className={"flex flex-col gap-4 pt-6 pb-6 pl-6 pr-6 " + _PANEL}>
            <Skeleton className="h-6 w-1/3" />
            <Skeleton className="h-3.5 w-full" />
            <Skeleton className="h-3.5 w-full" />
            <Skeleton className="h-3.5 w-2/3" />
            <div className="mt-2 flex gap-3">
                <Skeleton className="h-9 w-28 rounded-lg bg-primary/25" />
                <Skeleton className="h-9 w-24 rounded-lg" />
            </div>
        </div>
    </div>;
}


cl def:pub app() -> JsxElement {
    _applyPreviewTheme();
    sentinel = "__JAC_BUILDER" + "_BUILD_PROMPT__";
    hasPrompt = BUILD_PROMPT != sentinel;

    layout = "app";
    low = BUILD_PROMPT.lower();
    for pair in _HINTS {
        if layout == "app" and pair[0] in low {
            layout = pair[1];
        }
    }

    skeleton = <AppSkeleton />;
    if layout == "dashboard" {
        skeleton = <DashboardSkeleton />;
    } elif layout == "landing" {
        skeleton = <LandingSkeleton />;
    } elif layout == "chat" {
        skeleton = <ChatSkeleton />;
    } elif layout == "shop" {
        skeleton = <ShopSkeleton />;
    } elif layout == "blog" {
        skeleton = <BlogSkeleton />;
    }

    if not hasPrompt {
        return <div className="flex min-h-screen w-full items-center justify-center bg-background pt-8 pb-8 pl-8 pr-8 text-foreground">
            <div className="flex max-w-2xl flex-col items-center gap-6 text-center">
                <div className="select-none text-7xl" role="img" aria-label="sparkles">
                    {"✨"}
                </div>
                <p className="text-2xl font-medium leading-snug text-foreground sm:text-3xl">
                    {"When you start to build, changes will appear here."}
                </p>
            </div>
        </div>;
    }

    return <div className="flex min-h-screen w-full flex-col gap-6 bg-background pt-8 pb-8 pl-6 pr-6 text-foreground sm:pl-8 sm:pr-8">
        <div className="flex w-full flex-col gap-4">
            <div className="flex items-center gap-2.5">
                <span className="inline-block size-2 animate-pulse rounded-full bg-primary" />
                <span className="text-[11px] font-medium uppercase tracking-[0.22em] text-muted-foreground">
                    {"jac builder"}
                </span>
            </div>
            <h1 className="text-2xl font-semibold leading-tight tracking-tight sm:text-3xl">
                {"Cooking your app"}
                <span className="animate-pulse text-primary">{"…"}</span>
            </h1>
            <blockquote className="line-clamp-3 max-h-24 w-full max-w-3xl overflow-hidden border-l-2 border-primary/40 pt-1 pb-1 pl-4 text-base italic text-muted-foreground">
                {BUILD_PROMPT}
            </blockquote>
        </div>

        <div className="flex w-full flex-1 items-start opacity-80" aria-hidden="true">
            {skeleton}
        </div>

        <p className="w-full text-xs leading-relaxed tracking-wide text-muted-foreground/70">
            {"Hang tight — JacCoder is wiring this up. The preview refreshes the moment files land."}
        </p>
    </div>;
}
