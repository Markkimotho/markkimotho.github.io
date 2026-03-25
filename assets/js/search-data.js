// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "about",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-blog",
          title: "blog",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/blog/";
          },
        },{id: "nav-projects",
          title: "projects",
          description: "A growing collection of my projects made for work and fun alike.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/projects/";
          },
        },{id: "nav-repositories",
          title: "repositories",
          description: "Here, you will find my personal repository, and a couple of others that I fancy. I promise to commit more to github so that I improve my grade.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/repositories/";
          },
        },{id: "nav-cv",
          title: "cv",
          description: "This page holds my CV. You can read/review/critique it right from here. Or better yet, you can download it by clicking the top right &quot;pdf&quot; icon ☝🏽. Then you can read/review/critique.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "dropdown-projects",
              title: "projects",
              description: "",
              section: "Dropdown",
              handler: () => {
                window.location.href = "";
              },
            },{id: "dropdown-blog",
              title: "blog",
              description: "",
              section: "Dropdown",
              handler: () => {
                window.location.href = "/blog/";
              },
            },{id: "post-sketchbook-my-self-hosted-drawing-app",
      
        title: "Sketchbook: My Self-Hosted Drawing App",
      
      description: "A self-hosted, real-time collaborative drawing app built for artists who miss the feel of old paper.",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2026/sketchbook/";
        
      },
    },{id: "post-building-a-production-grade-json-parser-from-scratch",
      
        title: "Building a Production-Grade JSON Parser from Scratch",
      
      description: "A robust, scalable JSON parser written in Python with comprehensive error handling, full JSON spec support, and a web interface for real-time validation.",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2025/building-production-grade-json-parser/";
        
      },
    },{id: "news-i-just-published-my-website-again",
          title: 'I Just Published My Website, Again!',
          description: "",
          section: "News",handler: () => {
              window.location.href = "/news/announcement_4/";
            },},{id: "projects-ccwc-custom-file-statistics-tool",
          title: 'ccwc - Custom File Statistics Tool',
          description: "A command-line utility providing file statistics similar to Unix wc",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ccwc/";
            },},{id: "projects-financial-transaction-monitoring-amp-analytics-tool",
          title: 'Financial Transaction Monitoring &amp;amp; Analytics Tool',
          description: "Comprehensive financial tracking platform with Django, PostgreSQL, and Redis",
          section: "Projects",handler: () => {
              window.location.href = "/projects/financial-monitoring-tool/";
            },},{id: "projects-lumina-analytics-dashboard",
          title: 'Lumina Analytics Dashboard',
          description: "High-performance interactive data visualization with real-time updates and AI insights",
          section: "Projects",handler: () => {
              window.location.href = "/projects/lumina-analytics/";
            },},{id: "projects-make-an-order-order-management-service",
          title: 'Make-An-Order - Order Management Service',
          description: "A RESTful service for managing customers and orders with Google OAuth and SMS notifications",
          section: "Projects",handler: () => {
              window.location.href = "/projects/make-an-order/";
            },},{id: "projects-monty-stack-queue-interpreter",
          title: 'Monty - Stack/Queue Interpreter',
          description: "A simple interpreter for stack and queue operations in C",
          section: "Projects",handler: () => {
              window.location.href = "/projects/monty/";
            },},{id: "projects-printf-printf-reimplementation",
          title: 'Printf - Printf Reimplementation',
          description: "A custom C implementation of the printf standard library function",
          section: "Projects",handler: () => {
              window.location.href = "/projects/printf/";
            },},{id: "projects-sdl-c-raycasting-engine",
          title: 'SDL C Raycasting Engine',
          description: "A lightweight Wolfenstein 3D-inspired raycasting engine built with SDL2",
          section: "Projects",handler: () => {
              window.location.href = "/projects/sdl-c-raycasting/";
            },},{id: "projects-sketchbook-self-hosted-drawing-app",
          title: 'Sketchbook - Self-Hosted Drawing App',
          description: "A real-time collaborative drawing application with stylus support and pressure sensitivity",
          section: "Projects",handler: () => {
              window.location.href = "/projects/sketchbook/";
            },},{id: "projects-voxail-ai-powered-audio-transcription-platform",
          title: 'Voxail - AI-Powered Audio Transcription Platform',
          description: "Full-stack transcription platform with Google Gemini 2.0 Flash, 15+ specialized AI tasks, and live recording",
          section: "Projects",handler: () => {
              window.location.href = "/projects/voxail/";
            },},{
        id: 'social-email',
        title: 'email',
        section: 'Socials',
        handler: () => {
          window.open("mailto:%6B%69%6D%6F%74%68%6F%6D%61%72%6B%39%33@%67%6D%61%69%6C.%63%6F%6D", "_blank");
        },
      },{
        id: 'social-github',
        title: 'GitHub',
        section: 'Socials',
        handler: () => {
          window.open("https://github.com/markkimotho", "_blank");
        },
      },{
        id: 'social-linkedin',
        title: 'LinkedIn',
        section: 'Socials',
        handler: () => {
          window.open("https://www.linkedin.com/in/mark-tinega", "_blank");
        },
      },{
        id: 'social-medium',
        title: 'Medium',
        section: 'Socials',
        handler: () => {
          window.open("https://medium.com/@ktinega", "_blank");
        },
      },{
        id: 'social-rss',
        title: 'RSS Feed',
        section: 'Socials',
        handler: () => {
          window.open("/feed.xml", "_blank");
        },
      },{
        id: 'social-custom_social',
        title: 'Custom_social',
        section: 'Socials',
        handler: () => {
          window.open("https://ktinega.substack.com/", "_blank");
        },
      },{
      id: 'light-theme',
      title: 'Change theme to light',
      description: 'Change the theme of the site to Light',
      section: 'Theme',
      handler: () => {
        setThemeSetting("light");
      },
    },
    {
      id: 'dark-theme',
      title: 'Change theme to dark',
      description: 'Change the theme of the site to Dark',
      section: 'Theme',
      handler: () => {
        setThemeSetting("dark");
      },
    },
    {
      id: 'system-theme',
      title: 'Use system default theme',
      description: 'Change the theme of the site to System Default',
      section: 'Theme',
      handler: () => {
        setThemeSetting("system");
      },
    },];
