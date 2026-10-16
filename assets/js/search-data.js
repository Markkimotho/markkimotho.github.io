// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "About",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-blog",
          title: "Blog",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/blog/";
          },
        },{id: "nav-projects",
          title: "Projects",
          description: "A growing collection of my projects made for work and fun alike.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/projects/";
          },
        },{id: "nav-repositories",
          title: "Repositories",
          description: "Code, experiments, and work in progress.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/repositories/";
          },
        },{id: "nav-cv",
          title: "CV",
          description: "If you want to collaborate or hire me, this is your page",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "nav-people",
          title: "People",
          description: "The person behind the work",
          section: "Navigation",
          handler: () => {
            window.location.href = "/people/";
          },
        },{id: "post-separating-users-from-customers-building-a-multi-role-pos-system",
      
        title: "Separating Users from Customers: Building a Multi-Role POS System",
      
      description: "How a point of sale system separates staff accounts from customer records to keep operations clean and let each role do what it needs",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2026/separating-users-from-customers/";
        
      },
    },{id: "post-building-a-pos-system-with-flask-order-management-and-real-time-inventory",
      
        title: "Building a POS System with Flask: Order Management and Real-Time Inventory",
      
      description: "How I built an ordering system that tracks inventory, manages customers, and sends SMS notifications",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2026/building-pos-system-flask/";
        
      },
    },{id: "post-building-a-local-rag-chatbot-to-actually-understand-how-ai-reads-documents",
      
        title: "Building a Local RAG Chatbot to Actually Understand How AI Reads Documents",
      
      description: "A fully local, privacy-first document chatbot built with LangChain, Ollama, and ChromaDB to learn how LLMs, retrieval-augmented generation, vector databases, and conversation memory actually work under the hood.",
      section: "Posts",
      handler: () => {
        
          window.location.href = "/blog/2026/building-rag-chatbot/";
        
      },
    },{id: "post-sketchtogether-my-self-hosted-drawing-app",
      
        title: "SketchTogether: My Self-Hosted Drawing App",
      
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
    },{id: "news-announcing-a-series-about-the-web",
          title: 'Announcing a series about the web',
          description: "",
          section: "News",handler: () => {
              window.location.href = "/news/web-series-announcement/";
            },},{id: "news-i-just-published-my-website-again",
          title: 'I Just Published My Website, Again!',
          description: "",
          section: "News",handler: () => {
              window.location.href = "/news/announcement_4/";
            },},{id: "news-machine-learning-engineer-at-safaricom",
          title: 'Machine Learning Engineer at Safaricom',
          description: "",
          section: "News",handler: () => {
              window.location.href = "/news/announcement_5/";
            },},{id: "projects-video-publishing-automation",
          title: 'Video Publishing Automation',
          description: "A private tool for scheduling and uploading videos across social platforms",
          section: "Projects",handler: () => {
              window.location.href = "/projects/adspower-video-automation/";
            },},{id: "projects-automation-scripts-amp-utils",
          title: 'Automation Scripts &amp;amp; Utils',
          description: "Reusable bash &amp; Python automation for the everyday tasks developers repeat",
          section: "Projects",handler: () => {
              window.location.href = "/projects/automation-scripts-utils/";
            },},{id: "projects-batch-image-generator",
          title: 'Batch Image Generator',
          description: "A desktop app that turns spreadsheet prompts into batches of generated images",
          section: "Projects",handler: () => {
              window.location.href = "/projects/batch-image-generator/";
            },},{id: "projects-ccwc-custom-file-statistics-tool",
          title: 'ccwc - Custom File Statistics Tool',
          description: "A command-line utility providing file statistics similar to Unix wc",
          section: "Projects",handler: () => {
              window.location.href = "/projects/ccwc/";
            },},{id: "projects-edusight-africa-ai-student-risk-assessment-platform",
          title: 'EduSight Africa - AI Student Risk Assessment Platform',
          description: "Machine learning platform predicting student learning risk across African schools with cultural context and multilingual support",
          section: "Projects",handler: () => {
              window.location.href = "/projects/edusight-africa/";
            },},{id: "projects-etch-a-sketch",
          title: 'Etch a Sketch',
          description: "A small browser drawing toy with a resizable grid, color picker, eraser, and clear button",
          section: "Projects",handler: () => {
              window.location.href = "/projects/etch-a-sketch/";
            },},{id: "projects-financial-transaction-monitoring-amp-analytics-tool",
          title: 'Financial Transaction Monitoring &amp;amp; Analytics Tool',
          description: "Comprehensive financial tracking platform with Django, PostgreSQL, and Redis",
          section: "Projects",handler: () => {
              window.location.href = "/projects/financial-monitoring-tool/";
            },},{id: "projects-lead-scoring-amp-routing-pipeline",
          title: 'Lead Scoring &amp;amp; Routing Pipeline',
          description: "An internal workflow for evaluating prospect websites and routing qualified leads",
          section: "Projects",handler: () => {
              window.location.href = "/projects/lead-scoring-pipeline/";
            },},{id: "projects-lumina-analytics-dashboard",
          title: 'Lumina Analytics Dashboard',
          description: "High-performance interactive data visualization with real-time updates and AI insights",
          section: "Projects",handler: () => {
              window.location.href = "/projects/lumina-analytics/";
            },},{id: "projects-make-an-order",
          title: 'Make-An-Order',
          description: "Point of sale system for managing orders, inventory, and customers",
          section: "Projects",handler: () => {
              window.location.href = "/projects/make-an-order/";
            },},{id: "projects-monty-stack-queue-interpreter",
          title: 'Monty - Stack/Queue Interpreter',
          description: "A simple interpreter for stack and queue operations in C",
          section: "Projects",handler: () => {
              window.location.href = "/projects/monty/";
            },},{id: "projects-preparationpalai-local-rag-study-assistant",
          title: 'PreparationPalAI - Local RAG Study Assistant',
          description: "A privacy-first study assistant with document RAG, quizzes, flashcards, and local LLMs",
          section: "Projects",handler: () => {
              window.location.href = "/projects/preparationpalai/";
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
            },},{id: "projects-semaje",
          title: 'Semaje',
          description: "Self-hosted speech-to-text and text-to-speech across 1,600+ languages",
          section: "Projects",handler: () => {
              window.location.href = "/projects/semaje/";
            },},{id: "projects-sketchtogether-self-hosted-drawing-app",
          title: 'SketchTogether - Self-Hosted Drawing App',
          description: "A real-time collaborative drawing application with stylus support and pressure sensitivity",
          section: "Projects",handler: () => {
              window.location.href = "/projects/sketchbook/";
            },},{id: "projects-tropehaven",
          title: 'Tropehaven',
          description: "A fiction wiki with article editing, discussion, and a draft-to-publication path",
          section: "Projects",handler: () => {
              window.location.href = "/projects/tropehaven/";
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
