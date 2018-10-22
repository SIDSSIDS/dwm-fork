/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Liberation Mono:pixelsize=16:antialias=true:autohint=true" };
static const char dmenufont[]       = "Liberation Mono:pixelsize=16:antialias=true:autohint=true";

static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_gray1,/*col_cyan,*/  col_cyan  },
};

/* tagging */
static const char *tags[] = { "main", "web", "msg", "nb"  };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class              instance    title       tags mask     isfloating   monitor */
	{ "Gimp",             NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",          NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Chromium",         NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Opera",            NULL,       NULL,       1 << 1,       0,           -1 },
	{ "NetBeans",         NULL,       NULL,       1 << 3,       0,           -1 },
	{ "Slack",            NULL,       NULL,       1 << 2,       0,           -1 },
	{ "Rocket.Chat",      NULL,       NULL,       1 << 2,       0,           -1 },
	{ "Franz",            NULL,       NULL,       1 << 2,       0,           -1 },
	{ "vlc",              NULL,       NULL,       0,            1,           -1 },
	{ "Gnome-calculator", NULL,       NULL,       0,            1,           -1 },
	{ "Gnome-calendar",   NULL,       NULL,       0,            1,           -1 },
	{ "Steam",            NULL,       NULL,       0,            1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.70; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",      tile },    /* first entry is default */
	{ "[F]",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]        = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]         = { "st", NULL };
static const char *slockcmd[]        = { "slock", NULL };
static const char *brightdown[]      = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/exec_and_popup", "xbacklight -dec 10", "backlight.sh" };
static const char *brightup[]        = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/exec_and_popup", "xbacklight -inc 10", "backlight.sh" };
static const char *kbdleddown[]      = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/exec_and_popup", "xbacklight -ctrl asus::kbd_backlight -dec 30", "kbd_backlight.sh" };
static const char *kbdledup[]        = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/exec_and_popup", "xbacklight -ctrl asus::kbd_backlight -inc 30", "kbd_backlight.sh" };
static const char *toggle_touchpad[] = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/exec_and_popup", "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/touchpad toggle", "touchpad.sh" };
static const char *volume_mute[]     = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/exec_and_popup", "pamixer -t",      "volume.sh" };
static const char *volume_increase[] = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/exec_and_popup", "pamixer -i 5 -u", "volume.sh" };
static const char *volume_decrease[] = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/exec_and_popup", "pamixer -d 5",    "volume.sh" };
static const char *toggle_work[]     = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/toggle_work"};
static const char *dict_help[]       = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/dict_help"};
static const char *reminder_add[]    = { "/home/sids/distributives/dwm/dwm-git/src/dwm/bin/reminder", "add", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan , "-sf", col_gray4, NULL };
static const char *dclipcmd_paste[]  = { "dclip", "paste", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan , "-sf", col_gray4, NULL };
static const char *dclipcmd_paste2[] = { "dclip", "paste_and_click", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan , "-sf", col_gray4, NULL };

static Key keys[] = {
	/* modifier                     key                         function        argument */
	{ MODKEY,                       XK_p,                       spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return,                  spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,                       togglebar,      {0} },
	{ MODKEY,                       XK_j,                       focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,                       focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,                       incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,                       incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,                       setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,                       setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_l,                       spawn,          {.v = slockcmd } },
	{ MODKEY,                       XK_Return,                  zoom,           {0} },
	{ MODKEY,                       XK_Tab,                     view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,                       killclient,     {0} },
	{ MODKEY,                       XK_t,                       setlayout,      {.v = &layouts[0]} },
        { MODKEY|ControlMask,           XK_t,                       spawn,          {.v = dict_help } },
	{ MODKEY,                       XK_f,                       setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,                       setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,                   setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,                   togglefloating, {0} },
	{ MODKEY,                       XK_s,                       togglesticky,   {0} },
	{ MODKEY,                       XK_0,                       view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,                       tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,                   focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,                  focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,                   tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,                  tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                                       0)
	TAGKEYS(                        XK_2,                                       1)
	TAGKEYS(                        XK_3,                                       2)
	TAGKEYS(                        XK_4,                                       3)
	TAGKEYS(                        XK_5,                                       4)
	TAGKEYS(                        XK_6,                                       5)
	TAGKEYS(                        XK_7,                                       6)
	TAGKEYS(                        XK_8,                                       7)
	TAGKEYS(                        XK_9,                                       8)
	{ MODKEY|ShiftMask,             XK_q,                       quit,           {0} },
	{ 0,                            XF86XK_KbdBrightnessDown,   spawn,          {.v = kbdleddown } },
	{ 0,                            XF86XK_KbdBrightnessUp,     spawn,          {.v = kbdledup   } },
	{ 0,                            XF86XK_MonBrightnessDown,   spawn,          {.v = brightdown } },
	{ 0,                            XF86XK_MonBrightnessUp,     spawn,          {.v = brightup   } },
	{ 0,                            XF86XK_TouchpadToggle,      spawn,          {.v = toggle_touchpad } },
	{ 0,                            XF86XK_AudioLowerVolume,    spawn,          {.v = volume_decrease } },
	{ 0,                            XF86XK_AudioMute,           spawn,          {.v = volume_mute } },
	{ 0,                            XF86XK_AudioRaiseVolume,    spawn,          {.v = volume_increase } },
        { MODKEY|ControlMask,           XK_c,                       spawn,          SHCMD("exec dclip copy") },
        { MODKEY|ControlMask,           XK_x,                       spawn,          {.v = dclipcmd_paste } },
        { MODKEY|ControlMask,           XK_v,                       spawn,          {.v = dclipcmd_paste2 } },
        { MODKEY,                       XK_w,                       spawn,          {.v = toggle_work } },
        { MODKEY,                       XK_r,                       spawn,          {.v = reminder_add } },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
