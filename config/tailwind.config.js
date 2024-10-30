module.exports = {
  purge: {
    enabled: process.env.NODE_ENV === 'production',
    mode: 'all',
    content: [
      'lib/web/templates/*.ml',
      'lib/web/views/*.ml',
      'lib/annotation_tool/*.ml',
      'lib/annotation_tool/**/*.ml',
    ],
  },
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', 'sans-serif'],
      },
    },
  },
  variants: {
    margin: ['responsive', 'first'],
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ],
}
