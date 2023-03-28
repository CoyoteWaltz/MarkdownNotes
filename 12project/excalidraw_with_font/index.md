> [Excalidraw](https://github.com/excalidraw/excalidraw) is an excellent white board drawing tools with hand-drawn style. But Simplified Chinese font is not hand-drawn style and actually not pretty. Therefore, I forked the github repo and try to add my favour Simplified Chinese fonts.

I want to spilt to some steps:

1. Fork the repo.
2. Find some fonts like [小赖字体](https://github.com/lxgw/kose-font), [霞鹜文楷](https://github.com/lxgw/LxgwWenKai)
3. Modify code to add custom font family.
4. Build successfully and pass the test.
5. Depoly my forked project Online!

## The Repo

Fork to [my repo](https://github.com/CoyoteWaltz/excalidraw) and clone to local.

## Find fonts

Get font file:

- for [小赖字体](https://github.com/lxgw/kose-font): Download the zip file and get the `ttf` file as you want.
- for [霞鹜文楷](https://github.com/lxgw/LxgwWenKai): Download the `ttf` file from the release page.

Move font files into `public` directory.

And add `@font-face` in `public/fonts.css`.

## Modify code

> Figure out how font family change in Excalidraw.
>
> Previously, you should be familiar with React. BTW the state framework is Jotai.

### Run the Project

Install all dependencies with yarn and `yarn start`, Excalidraw runs on `localhost:3000`

### How font family Changes

- App entry JSX is located in `src/excalidraw-app/index.tsx`
- Default font family config locates in `src/constants.ts`.`FONT_FAMILY`
- Where fonts options will be rendered is located in `src/actions/actionProperties.tsx`
  - `actionChangeFontFamily` is an action triggered when clicking some elements relevant with text(text inputing, text elements on canvas, ...)
    - It renders font options with `PanelComponent` method onto the _Left Island Menu_. When we choose a font(click the font button), calls `updateData` from `src/actions/manager.tsx`, eventually calls the `actionChangeFontFamily.perform`.
    - `perform` filters the current selected elements on canvas and change their font family into the target value.
- Map the current font family value to the elements:
  - Trace `FONT_FAMILY` to `src/utils.ts` file's `getFontFamilyString`
    - Which returns the **key of** `FONT_FAMILY` as the `font-family` value in CSS.
    - And the Text Elements are rendered with Style in `renderElementToSvg`.
    - **So the key is committed to the CSS @font-face's `font-family`.**
- BTW Action Framework: All actions will be registered(via `register`) to the global `actions` which Excalidraw will use them as menu. Actions will be matched via their name(e.g. `changeFontFamily`).

Cool, just a glimpse of Excalidraw App.

### Add fonts

The principal is **Minimal Changes**: Change the least files by origin to get the best adoption with upcoming features from the `origin repo`.

Steps:

- Declare our `CUSTON_FONT_FAMILY` with the key of what we add in `font-family`. And Merge with `FONT_FAMILY`.
- Add new font options in `actionChangeFontFamily` to show our new fonts.

Code: [Commit](https://github.com/CoyoteWaltz/excalidraw/commit/c24585cf996ea7cd2086f6f08b74642ec926208d#diff-a42db833da75f97b018177d83fbb6721eaa612c256d41c0495148ccd3119aa14)

## Depoly

TODO: With Vercel, Github Bot, Vercel Config, Github Actions

## TODOs

- [ ] Create svg icon for new fonts.
- [ ] Find more custom features...
