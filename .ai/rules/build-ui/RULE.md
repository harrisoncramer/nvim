---
globs: ['*.ts', "*.tsx", "*.js", "*.jsx"]
alwaysApply: true
---

# Building UI with Kit

Kit is Chariot's design system built on shadcn/ui with Radix UI primitives and Tailwind CSS v4.

> **CRITICAL: Always use semantic Tailwind tokens for colors.**
> - Never use hardcoded hex values (e.g., `text-[#051a2e]`, `bg-[#209ae5]`)
> - Never use generic Tailwind colors (e.g., `text-gray-500`, `bg-blue-500`)
> - Never use legacy dashboard colors (e.g., `text-darkGray`, `bg-primaryBlue`)
> - Always use Kit tokens (e.g., `text-foreground`, `bg-primary`, `bg-muted`)

## Step 1: Discover Available Components & Tokens

Before building or migrating UI, inspect the Kit package to understand what's available:

1. **Read the barrel export** to see all components:
   ```
   node_modules/@chariot-giving/kit/index.ts
   ```
2. **Read the Tailwind theme** to see all available color/shadow classes:
   ```
   node_modules/@chariot-giving/kit/styles/tailwind.css
   ```
3. **Read the CSS tokens** for semantic variable definitions:
   ```
   node_modules/@chariot-giving/kit/styles/tokens.css
   ```
4. **Read a specific component** to understand its props/variants:
   ```
   node_modules/@chariot-giving/kit/components/<ComponentName>.tsx
   ```

## Step 2: Import from Kit

```typescript
// Components - always use barrel import
import { Button, Card, Input, Dialog, Tag } from "@chariot-giving/kit";

// Utility - className merging
import { cn } from "@chariot-giving/kit/lib/utils";

// Assets - logos
import chariotLogo from "@chariot-giving/kit/assets/logo/full/navy/chariot_full-logo_navy.svg";
```

## Step 3: Use Semantic Tokens for Styling

### Core Semantic Tokens

| Token | Resolved Color | Usage |
|-------|---------------|-------|
| `foreground` | `#051A2E` (chariot-midnight) | Primary text |
| `foreground-alt` | `#404040` (grayscale-700) | Body text |
| `chariot-text` | `#364757` | Secondary/label text |
| `muted-foreground` | `#737373` (grayscale-500) | Placeholders, helper text |
| `primary` | `#209AE5` (chariot-glacier) | Buttons, links, accents |
| `primary-foreground` | `#FAFAFA` | Text on primary backgrounds |
| `destructive` | `#DC2626` (red-600) | Errors, danger actions |
| `background` | `#FFFFFF` | Page backgrounds |
| `card` | `#FFFFFF` | Card backgrounds |
| `muted` | `#F5F5F5` (grayscale-100) | Muted backgrounds |
| `border` | `#E5E5E5` (grayscale-200) | Borders, dividers |
| `input` | `#E5E5E5` | Input borders |

### Brand & Extended Tokens

| Token | Usage |
|-------|-------|
| `cream-25` through `cream-100` | Warm neutral backgrounds |
| `chariot-glacier`, `chariot-sky` | Brand blue accents |
| `chariot-navy`, `chariot-midnight` | Brand dark accents |
| `grayscale-50` through `grayscale-950` | Neutral scale |
| `red-50` through `red-950` | Error/danger scale |
| `green-50` through `green-950` | Success scale |
| `blue-50` through `blue-950` | Info scale |
| `shadow-soft` | Elevation shadow for cards/dialogs |

## Available Components (54 total)

### Buttons & Actions
`Button` (variants: default/destructive/outline/secondary/ghost/link), `IconButton`, `Toggle`, `ToggleGroup`, `ButtonGroup`

### Form Controls
`Input`, `InputGroup`, `InputOTP`, `Textarea`, `Checkbox`, `RadioGroup`, `Switch`, `Select`, `Slider`, `Label`, `Field` (with `FieldLabel`, `FieldDescription`, `FieldError`, `FieldGroup`, `FieldSet`)

### Layout & Structure
`Card` (with `CardHeader`, `CardFooter`, `CardTitle`, `CardDescription`, `CardContent`), `Tabs`, `Accordion`, `Collapsible`, `Separator`, `ScrollArea`, `Resizable`, `AspectRatio`

### Overlays & Popups
`Dialog`, `AlertDialog`, `Sheet`, `Drawer`, `Popover`, `HoverCard`, `Tooltip`, `DropdownMenu`, `ContextMenu`, `Command`

### Data Display
`Table`, `Tag` (status: neutral/info/warning/danger/success), `Badge`, `Avatar`, `Item` (with `ItemMedia`, `ItemContent`, `ItemActions`), `Kbd`, `Empty`

### Feedback
`Alert`, `Progress`, `Skeleton`, `Spinner`, `Sonner` (toasts)

### Navigation
`Breadcrumb`, `NavigationMenu`, `Menubar`, `Pagination`

### App Shell
`SidebarProvider`, `Sidebar`, `AppSidebar`, `AppHeader`, `AppContent`

### Hooks
`useSidebar`, `useIsMobile`

## Migrating Old Components

The old Kit components (`@/kit`) are deprecated. When touching files that use them, migrate to `@chariot-giving/kit`.

For detailed migration mappings, read [migration-reference.md](migration-reference.md).

### Quick Component Migration

| Old (`@/kit`) | New (`@chariot-giving/kit`) |
|---------------|----------------------------|
| `KitButton` | `Button` |
| `KitCard` | `Card` + sub-components |
| `KitTag` | `Tag` |
| `KitCallout` | `Alert` |
| `Status` type from `@/kit/types` | `TagProps["status"]` |
| `classNames()` from `@/lib/helpers` | `cn()` from `@chariot-giving/kit/lib/utils` |

### Quick KitButton Migration

```tsx
// OLD
import { KitButton } from "@/kit";
<KitButton text="Save" kind="primary" variant="fill" size="medium" onClick={handleSave} />
<KitButton text="Cancel" kind="neutral" variant="outline" onClick={handleCancel} />
<KitButton text="Delete" kind="danger" variant="fill" onClick={handleDelete} />

// NEW
import { Button } from "@chariot-giving/kit";
<Button onClick={handleSave}>Save</Button>
<Button variant="outline" onClick={handleCancel}>Cancel</Button>
<Button variant="destructive" onClick={handleDelete}>Delete</Button>
```

Key differences:
- Children instead of `text` prop
- `kind` + `variant` collapse into single `variant` prop
- `kind="primary" variant="fill"` = `Button` (default)
- `kind="neutral" variant="outline"` = `Button variant="outline"`
- `kind="danger"` = `Button variant="destructive"`
- `kind="neutral" variant="ghost"` = `Button variant="ghost"`
- `size`: "small" = `size="sm"`, "medium" = default, "large" = `size="lg"`
- `leftIcon`/`rightIcon` (FontAwesome) = use lucide-react icons as children
- `loading` = handle with `disabled` + `Spinner` component

### Quick KitCard Migration

```tsx
// OLD
import { KitCard } from "@/kit";
<KitCard title="Settings" description="Manage account" rightHeaderContent={<button>Edit</button>}>
  {children}
</KitCard>

// NEW
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@chariot-giving/kit";
<Card>
  <CardHeader className="flex flex-row items-center justify-between">
    <div>
      <CardTitle>Settings</CardTitle>
      <CardDescription>Manage account</CardDescription>
    </div>
    <button>Edit</button>
  </CardHeader>
  <CardContent>{children}</CardContent>
</Card>
```

### Quick Color Migration

| Old Class | New Class |
|-----------|-----------|
| `text-darkGray` | `text-foreground-alt` or `text-chariot-text` |
| `text-slateGray` | `text-muted-foreground` |
| `text-cosmicNight` | `text-foreground` |
| `text-nightShade` | `text-foreground` |
| `text-midnightBlue` | `text-foreground` |
| `text-primaryBlue` | `text-primary` |
| `text-duskyBlue` | `text-primary` |
| `text-peachyRose` | `text-destructive` |
| `text-cherryRed` | `text-destructive` |
| `text-softRed` | `text-destructive` |
| `bg-primaryBlue` | `bg-primary` |
| `bg-lightGray` | `bg-muted` |
| `bg-aquaHaze` | `bg-muted` or `bg-cream-25` |
| `border-fogBlue` | `border-border` |
| `border-silverCloud` | `border-border` |
| `focus:border-primaryBlue` | `focus:border-primary` |
| `focus:ring-primaryBlue` | `focus:ring-ring` |
| `hover:bg-lightGray` | `hover:bg-muted` |
| `hover:text-primaryBlue` | `hover:text-primary` |

For the complete old-to-new color mapping, read [migration-reference.md](migration-reference.md).

## Figma MCP Workflow

When a user provides a Figma link, use the **Figma Desktop** MCP server to extract design details. The server is named `user-Figma Desktop` and provides these tools:

| Tool | Purpose |
|------|---------|
| `get_design_context` | Extract component structure, layout, and styles from a Figma node or file |
| `get_screenshot` | Capture a visual screenshot of a Figma frame or component |
| `get_metadata` | Get file-level metadata (name, last modified, pages) |
| `get_variable_defs` | Extract Figma variable definitions (colors, spacing, typography) |
| `create_design_system_rules` | Generate design system rules from Figma variables |
| `get_figjam` | Extract content from FigJam boards |

### Step-by-step

1. **Inspect Kit source first** - Read `node_modules/@chariot-giving/kit/index.ts` and `styles/tokens.css` to know what components and tokens are available
2. **Get a screenshot** - Call `get_screenshot` with the Figma URL to see the visual design
3. **Extract design context** - Call `get_design_context` with the Figma URL to get component structure, colors, spacing, and typography details
4. **Map Figma components to Kit** - Match Figma layers/components to Kit equivalents using the Component Mapping table above
5. **Map colors to semantic tokens** - Convert Figma hex values to Kit tokens (never use hex directly). Use the table below.
6. **Map spacing to Tailwind** - Convert pixel values to Tailwind spacing utilities. Use the Spacing & Sizing Reference below.
7. **Build the component** - Assemble using Kit components, semantic tokens, and Tailwind utilities

### Calling Figma MCP Tools

```
// Get a screenshot of a Figma frame
CallMcpTool server="user-Figma Desktop" toolName="get_screenshot"

// Extract design structure and styles
CallMcpTool server="user-Figma Desktop" toolName="get_design_context"

// Get variable definitions (design tokens)
CallMcpTool server="user-Figma Desktop" toolName="get_variable_defs"
```

Pass the Figma URL or node ID as arguments. The tools accept the Figma link the user provides.

### Figma Hex to Token Mapping

| Figma Hex | Token |
|-----------|-------|
| `#051A2E` (dark navy) | `text-foreground` |
| `#364757` | `text-chariot-text` |
| `#404040` | `text-foreground-alt` |
| `#697682`, `#737373` | `text-muted-foreground` |
| `#209AE5` | `bg-primary` / `text-primary` |
| `#DC2626` | `text-destructive` |
| `#E5E5E5` | `border-border` |
| `#F5F5F5` | `bg-muted` |
| `#EFEEEC` | `bg-cream-25` |
| `#EFECE6` | `bg-cream-50` |
| `#FFFFFF` | `bg-background` / `bg-card` |
| `#D4D4D4` | `border-border-3` |
| `#171717` | `text-grayscale-900` |
| `#FAFAFA` | `bg-grayscale-50` |

If a hex value from Figma doesn't match this table exactly, find the closest semantic token by reading `node_modules/@chariot-giving/kit/styles/tailwind.css`.

## Common Patterns

```tsx
// Form card
<div className="rounded-lg bg-cream-25 p-8">
  <h1 className="text-xl font-medium text-foreground">Title</h1>
  <p className="text-muted-foreground">Description</p>
  <Input className="bg-white" placeholder="Email" />
  <Button>Submit</Button>
</div>

// Error state
<span className="text-sm text-destructive">Error message</span>

// Status tags
<Tag status="success">Completed</Tag>
<Tag status="danger">Failed</Tag>

// Card with shadow
<Card className="shadow-soft">
  <CardContent>Elevated card</CardContent>
</Card>
```

## Spacing & Sizing Reference

| px | Tailwind | | px | Tailwind |
|----|----------|---|----|----------|
| 4 | `1` | | 24 | `6` |
| 8 | `2` | | 32 | `8` |
| 12 | `3` | | 40 | `10` |
| 16 | `4` | | 48 | `12` |
| 20 | `5` | | 64 | `16` |

**Border radius:** 4px=`rounded`, 6px=`rounded-md`, 8px=`rounded-lg`, 12px=`rounded-xl`

**Font size:** 12px=`text-xs`, 14px=`text-sm`, 16px=`text-base`, 18px=`text-lg`, 20px=`text-xl`

## Anti-patterns

```tsx
// WRONG - old Kit imports
import { KitButton, KitTag } from "@/kit";

// WRONG - hardcoded/legacy colors
<h1 className="text-[#051a2e]">Title</h1>
<h1 className="text-darkGray">Title</h1>
<button className="bg-primaryBlue">Submit</button>
<span className="text-peachyRose">Error</span>

// CORRECT
import { Button, Tag } from "@chariot-giving/kit";
<h1 className="text-foreground">Title</h1>
<Button>Submit</Button>
<span className="text-destructive">Error</span>
```

## Best Practices

1. **Read Kit source first** - Check `index.ts` and component files before building
2. **Never hardcode colors** - Use semantic tokens from `tailwind.css`
3. **Check Kit first** - Before creating custom components
4. **Use `cn()` utility** - For conditional classNames (replaces `classNames()`)
5. **Import from `@chariot-giving/kit`** - Never from `@/kit`
6. **Migrate on touch** - When editing a file with old Kit imports, migrate them
7. **Prefer Kit defaults** - Only override component styles when necessary

# Kit Migration Reference

Detailed mappings for migrating from old Kit (`@/kit`) to new Kit (`@chariot-giving/kit`).

## Component Migration

### KitButton -> Button

| Old Prop | New Equivalent |
|----------|---------------|
| `text="Label"` | Children: `<Button>Label</Button>` |
| `kind="primary" variant="fill"` | Default: `<Button>` |
| `kind="primary" variant="outline"` | `<Button variant="outline" className="border-primary text-primary">` |
| `kind="primary" variant="ghost"` | `<Button variant="ghost" className="text-primary">` |
| `kind="neutral" variant="fill"` | `<Button variant="secondary">` |
| `kind="neutral" variant="outline"` | `<Button variant="outline">` |
| `kind="neutral" variant="ghost"` | `<Button variant="ghost">` |
| `kind="danger" variant="fill"` | `<Button variant="destructive">` |
| `kind="danger" variant="outline"` | `<Button variant="outline" className="border-destructive text-destructive">` |
| `kind="danger" variant="ghost"` | `<Button variant="ghost" className="text-destructive">` |
| `kind="info"` | `<Button variant="outline">` (style to match) |
| `kind="pending"` | `<Button variant="secondary">` |
| `kind="secondary"` | `<Button variant="secondary">` |
| `size="x_small"` | `size="sm"` with smaller custom classes |
| `size="small"` | `size="sm"` |
| `size="medium"` | Default (no size prop) |
| `size="large"` | `size="lg"` |
| `leftIcon={faIcon}` | Put icon as child: `<Button><LucideIcon className="mr-2 h-4 w-4" />Label</Button>` |
| `rightIcon={faIcon}` | `<Button>Label<LucideIcon className="ml-2 h-4 w-4" /></Button>` |
| `centerIcon={faIcon}` | Use `IconButton`: `<IconButton><LucideIcon /></IconButton>` |
| `loading={true}` | `<Button disabled><Spinner className="mr-2" size="sm" />Label</Button>` |
| `disabled={true}` | `disabled` prop (same) |
| `link={{ href, target }}` | Wrap with Next.js `Link`: `<Button asChild><Link href={href}>Label</Link></Button>` |
| `type="submit"` | `type="submit"` (same) |
| `form="formId"` | `form="formId"` (same) |

### KitCard -> Card

| Old Pattern | New Pattern |
|-------------|-------------|
| `<KitCard title="T">` | `<Card><CardHeader><CardTitle>T</CardTitle></CardHeader></Card>` |
| `<KitCard description="D">` | `<Card><CardHeader><CardDescription>D</CardDescription></CardHeader></Card>` |
| `<KitCard title="T" description="D">content</KitCard>` | `<Card><CardHeader><CardTitle>T</CardTitle><CardDescription>D</CardDescription></CardHeader><CardContent>content</CardContent></Card>` |
| `rightHeaderContent={<btn>}` | Put in `CardHeader` with flex layout |
| `leftHeaderContent={<icon>}` | Put in `CardHeader` with flex layout |
| `noPadding={true}` | Use `className="p-0"` on Card or omit CardContent padding |

### KitTag -> Tag

| Old Pattern | New Pattern |
|-------------|-------------|
| `<KitTag status="success">` | `<Tag status="success">` |
| `<KitTag status="danger">` | `<Tag status="danger">` |
| `<KitTag status="warning">` | `<Tag status="warning">` |
| `<KitTag status="info">` | `<Tag status="info">` |
| `<KitTag status="neutral">` | `<Tag status="neutral">` |
| `<KitTag status="pending">` | `<Tag status="warning">` |
| `<KitTag status="primary">` | `<Tag status="info">` |
| `<KitTag status="secondary">` | `<Tag status="neutral">` |
| `<KitTag size="x_small">` | `<Tag>` (size handled via className) |
| `<KitTag size="small">` | `<Tag>` (default) |
| `<KitTag size="medium">` | `<Tag>` |

### KitCallout -> Alert

| Old Pattern | New Pattern |
|-------------|-------------|
| `<KitCallout kind="info" title="T" description="D">` | `<Alert><AlertIcon /><AlertTitle>T</AlertTitle><AlertDescription>D</AlertDescription></Alert>` |
| `<KitCallout kind="danger">` | `<Alert variant="destructive">` |
| `<KitCallout kind="warning">` | `<Alert>` (use warning icon) |
| `<KitCallout kind="neutral">` | `<Alert>` (default) |

## Color Migration

### Legacy Color -> Semantic Token

These are the old custom colors defined in `globals.css` and their Kit semantic replacements.

#### Text Colors

| Old | New | Notes |
|-----|-----|-------|
| `text-darkGray` (#414552) | `text-foreground-alt` or `text-chariot-text` | General body text |
| `text-slateGray` (#657482) | `text-muted-foreground` | Secondary/helper text |
| `text-cosmicNight` (#050F19) | `text-foreground` | Headings |
| `text-nightShade` (#171717) | `text-foreground` | Headings |
| `text-midnightBlue` (#1D2A36) | `text-foreground` | Headings |
| `text-gunmetalGray` (#454545) | `text-foreground-alt` | Body text |
| `text-steelBlueGray` (#82909E) | `text-muted-foreground` | Helper text |
| `text-foggyGray` (#ACB6C0) | `text-muted-foreground` | Disabled text |
| `text-primaryBlue` (#35BBF4) | `text-primary` | Links, active states |
| `text-skyBlue` (#35BBF4) | `text-primary` | Links, active states |
| `text-duskyBlue` (#596171) | `text-muted-foreground` or `text-primary` | Context-dependent |
| `text-tealBlue` (#1C78C9) | `text-primary` | Links |
| `text-oceanBlue` (#005DAD) | `text-primary` | Links |
| `text-peachyRose` (#ED6B5D) | `text-destructive` | Errors |
| `text-softRed` (#ED685D) | `text-destructive` | Errors |
| `text-cherryRed` (#DC1330) | `text-destructive` | Errors |
| `text-errorRed` (#C80000) | `text-destructive` | Errors |
| `text-alertErrorRed` (#C12727) | `text-destructive` | Errors |
| `text-successGreen` (#249225) | `text-green-600` | Success text |
| `text-pineGrove` (#217005) | `text-green-700` | Success text |
| `text-lushGreen` (#2F8524) | `text-green-600` | Success text |
| `text-sunsetOrange` (#FF9900) | `text-chariot-moss` or custom | Warning text |
| `text-goldenAmber` (#F1993A) | `text-chariot-moss` or custom | Warning text |
| `text-deepPurple` (#6328C4) | `text-chariot-bluebell` | Purple accent |
| `text-royalPurple` (#5E24C3) | `text-chariot-bluebell` | Purple accent |

#### Background Colors

| Old | New | Notes |
|-----|-----|-------|
| `bg-lightGray` (#EBEEF1) | `bg-muted` | Subtle backgrounds |
| `bg-aquaHaze` (#F6F8FA) | `bg-muted` or `bg-cream-25` | Card/section backgrounds |
| `bg-whisperGray` (#F9F9F9) | `bg-muted` | Hover states |
| `bg-mediumGray` (#EDF1F5) | `bg-muted` | Backgrounds |
| `bg-veryLightGrey` (#F9F9F9) | `bg-muted` | Backgrounds |
| `bg-offWhiteGray` (#EDEFEE) | `bg-cream-25` | Warm backgrounds |
| `bg-primaryBlue` (#35BBF4) | `bg-primary` | Primary buttons |
| `bg-skyBlue` (#35BBF4) | `bg-primary` | Primary buttons |
| `bg-rosePink` (#FFE5E5) | `bg-destructive-subtle` | Error backgrounds |
| `bg-mintWhisper` (#D7F7C2) | `bg-green-100` | Success backgrounds |
| `bg-lightCream` (#FDF4E9) | `bg-cream-50` | Warm backgrounds |
| `bg-ivoryYellow` (#FEFDE2) | `bg-cream-50` | Warning backgrounds |
| `bg-apricotTint` (#FFEFDB) | `bg-cream-50` | Warning backgrounds |
| `bg-powderBlue` (#CEF0FF) | `bg-blue-100` | Info backgrounds |
| `bg-lightSkyBlue` (#EBF8FE) | `bg-chariot-sky-50` | Info backgrounds |

#### Border Colors

| Old | New | Notes |
|-----|-----|-------|
| `border-fogBlue` (#DBE0E5) | `border-border` | General borders |
| `border-silverCloud` (#E0E6EB) | `border-border` | General borders |
| `border-softGray` (#E7E7E7) | `border-border` | General borders |
| `border-coolFog` (#E7ECF0) | `border-border` | General borders |
| `border-paleGray` (#D9D9D9) | `border-border` or `border-border-3` | Borders |
| `border-softBlueGray` (#BFC7CE) | `border-border-3` | Stronger borders |
| `border-primaryBlue` (#35BBF4) | `border-primary` | Active/focus borders |
| `border-peachyRose` (#ED6B5D) | `border-destructive` | Error borders |

#### Focus/Hover States

| Old | New |
|-----|-----|
| `focus:border-primaryBlue` | `focus:border-primary` |
| `focus:ring-primaryBlue` | `focus:ring-ring` |
| `focus-visible:outline-primaryBlue` | `focus-visible:outline-primary` or `focus-visible:ring-ring` |
| `hover:bg-lightGray` | `hover:bg-muted` |
| `hover:text-primaryBlue` | `hover:text-primary` |
| `hover:bg-primaryBlue/90` | `hover:bg-primary/90` |
| `disabled:bg-lightGray` | `disabled:bg-muted` |

## Utility Migration

| Old | New |
|-----|-----|
| `import { classNames } from "@/lib/helpers"` | `import { cn } from "@chariot-giving/kit/lib/utils"` |
| `classNames("a", condition && "b")` | `cn("a", condition && "b")` |

## Font Migration

| Old | New |
|-----|-----|
| `font-inter` | `font-brut` (for headlines) or remove (Inter is default body) |
| `font-matter` | Remove (use default) |

## Import Cleanup Checklist

When migrating a file:

1. Replace `import { KitButton, KitTag, ... } from "@/kit"` with named imports from `@chariot-giving/kit`
2. Replace `import { classNames } from "@/lib/helpers"` with `import { cn } from "@chariot-giving/kit/lib/utils"`
3. Replace `import { Status } from "@/kit/types"` with inline types or `TagProps["status"]`
4. Search for all legacy color classes and replace with semantic tokens
5. Replace `<button className="...">` with `<Button>` where appropriate
6. Remove FontAwesome icon imports if replacing with lucide-react icons
