# Workout Habit Tracking App

A SwiftUI recreation of [@LenardFloeren](https://twitter.com/LenardFloeren)'s workout habit tracking app concept, enhanced with additional functionalities and styled with Apple's modern interface design principles.

## Overview

This app helps users maintain a consistent workout routine by tracking their streak, managing rest days, and providing fallback options. The interface follows Apple's design language with rounded corners, subtle animations, and a clean aesthetic.

## Features

### Streak Tracking
- Visual display of current workout streak
- Streak resets if workouts are missed without available fallbacks

### Dynamic Rest Days
- Customizable rest days (0-7 days per week)
- Visual calendar display showing rest day distribution
- Intelligent rest day allocation throughout the week
- Rest days indicated with subtle icons in the calendar

### Fallback System
- 2 fallback days available
- Use fallbacks to maintain streak when working out on rest days
- Streak resets after using all fallbacks

### Workout Duration
- Flexible workout duration options (15, 30, or 45 minutes)
- Quick selection through native iOS wheel picker

### Modern UI Elements
- Apple-style rounded corners and shadows
- Native iOS sheet presentations
- Subtle animations and transitions
- Clean, minimalist calendar view

## Design Philosophy

The app combines the original concept by @LenardFloeren with Apple's interface guidelines to create a seamless, native iOS experience. It emphasizes:
- Clear visual hierarchy
- Intuitive interactions
- Minimal yet informative design
- Consistent visual language

## Technical Implementation

Built using:
- SwiftUI
- Native iOS components
- Apple's SF Symbols
- Modern iOS sheet presentations
- Dynamic calendar calculations
