-- =========================================================================
-- populate.sql
--
-- Seed data using real Morgan State University reference data:
--   * Colleges/schools           - morgan.edu/schools-colleges
--   * Departments                - morgan.edu/academics/departments-a-to-z
--   * Subject codes              - catalog.morgan.edu (e.g. COSC, EEGR, INSS)
--   * Course numbers and titles  - catalog.morgan.edu and program PDFs
--   * Building names (locations) - real campus buildings (McMechen Hall,
--                                  Calloway Hall, Schaefer Engineering, etc.)
--
-- Faculty and students are illustrative records that correctly reference
-- real departments and use Morgan's @morgan.edu email convention.
--
-- Designed for SQLite. Wraps in a transaction for atomic load.
-- Run after schema.sql:   sqlite3 mydb.sqlite < schema.sql
--                         sqlite3 mydb.sqlite < populate.sql
-- =========================================================================

BEGIN TRANSACTION;

-- Wipe existing data (in dependency order)
DELETE FROM messages;
DELETE FROM conversations;
DELETE FROM appointments;
DELETE FROM prerequisites;
DELETE FROM enrollments;
DELETE FROM meeting_days;
DELETE FROM section_meetings;
DELETE FROM sections;
DELETE FROM courses;
DELETE FROM colleges;
DELETE FROM departments;
DELETE FROM sessions;
DELETE FROM students;
DELETE FROM faculty;
DELETE FROM term;

-- Reset autoincrement counters
DELETE FROM sqlite_sequence;

-- ---------------------------------------------------------------------------
-- TERMS
-- ---------------------------------------------------------------------------
INSERT INTO term (id, name, begins, ends) VALUES
    (1, 'Fall 2024',   '2024-08-26', '2024-12-13'),
    (2, 'Spring 2025', '2025-01-27', '2025-05-16'),
    (3, 'Summer 2025', '2025-05-27', '2025-08-08'),
    (4, 'Fall 2025',   '2025-08-25', '2025-12-12'),
    (5, 'Spring 2026', '2026-01-26', '2026-05-15');

-- ---------------------------------------------------------------------------
-- COLLEGES / SCHOOLS  (source: morgan.edu/schools-colleges)
-- ---------------------------------------------------------------------------
INSERT INTO colleges (id, name) VALUES
    (1,  'James H. Gilliam, Jr. College of Liberal Arts'),
    (2,  'School of Architecture and Planning'),
    (3,  'Earl G. Graves School of Business and Management'),
    (4,  'School of Community Health and Policy'),
    (5,  'School of Computer, Mathematical and Natural Sciences'),
    (6,  'School of Education and Urban Studies'),
    (7,  'Clarence M. Mitchell, Jr. School of Engineering'),
    (8,  'School of Global Journalism and Communication'),
    (9,  'School of Social Work'),
    (10, 'College of Interdisciplinary and Continuing Studies');

-- ---------------------------------------------------------------------------
-- DEPARTMENTS  (source: morgan.edu/academics/departments-a-to-z)
-- Subject codes are the real codes used in Morgan's catalog.
-- ---------------------------------------------------------------------------

INSERT INTO departments (id, college_id, name, code, description) VALUES
    -- JAMES H. GILLIAM, JR. COLLEGE OF LIBERAL ARTS
    (1, 1, 'Economics', 'ECON', 'The Department of Economics in the James H. Gilliam, Jr. College of Liberal Arts offers the Bachelor of Science in Economics and an Economics minor, and contributes coursework to the universitys interdisciplinary minors and pre-MBA preparation. The departments mission is to provide a first-class educational opportunity for students from diverse backgrounds, with a curriculum grounded in microeconomic and macroeconomic theory, econometrics, money and banking, public finance, international trade, and labor economics. Students develop quantitative reasoning, data-analytic, and policy-evaluation skills that prepare them for careers in government, banking and finance, consulting, and non-profit research, as well as for graduate study in economics, public policy, business, and law. The department also hosts the doctoral track in economics within the universitys broader doctoral programs and supports faculty research on urban and minority economic development, health economics, and labor market disparities.'),
    (2, 1, 'English and Language Arts', 'ENGL', 'The Department of English and Language Arts is one of the foundational academic units of the College of Liberal Arts and is responsible for the Bachelor of Arts in English, an English minor, the Master of Arts in English, and the Doctor of Philosophy in English -- one of Morgans signature humanities doctorates. The department also delivers the universitys first-year composition sequence (Freshman Composition I and II), which all undergraduates complete, and supports the Morgan State University Writing Center serving students across every school and college. Curricular concentrations include literary studies (with strong programs in African American literature, the literature of the African diaspora, and American and British literature), language and linguistics, and writing and rhetoric. Faculty research and teaching emphasize the African American literary tradition, post-colonial and diaspora studies, and the rhetorical analysis of public discourse. Graduates pursue careers in teaching, publishing, law, technical writing, and the arts, and continue on to graduate and professional study.'),
    (3, 1, 'Fine and Performing Arts', 'ART', 'The Department of Fine and Performing Arts is a vibrant unit of the College of Liberal Arts headquartered in the Carl J. Murphy Fine Arts Center. The department brings together programs in studio art and visual arts, music (including the internationally acclaimed Morgan State University Choir), theatre arts, dance, and musical theatre, and offers the Bachelor of Arts in Art, the Bachelor of Arts in Music, the Master of Arts in Music, a music minor, and undergraduate work in theatre and dance. Through its visual-arts side it is closely connected to the James E. Lewis Museum of Art (JELMA), the cultural extension of the universitys fine arts program, which curates a permanent collection of African, African American, and modernist works. The departments performance side stages full theatrical seasons, choral concerts, and dance productions. The unit cultivates artists, performers, educators, and arts administrators while serving the entire university through general-education arts coursework.'),
    (4, 1, 'History, Geography, and Museum Studies', 'HIST', 'The Department of History, Geography, and Museum Studies offers the Bachelor of Arts in History, the Master of Arts in History, the Doctor of Philosophy in History, and the Master of Science in Museum Studies and Historical Preservation, which is one of only a small number of such programs nationally located at a Historically Black College or University. Geography coursework supports the universitys general-education and urban-studies programs. The department emphasizes the analytic and critical-thinking skills that prepare students for any profession in which evidence-based reasoning matters: law, public service, journalism, education, and curatorial work. Faculty specializations span African American history, the history of the African diaspora, U.S. and Atlantic-world history, and public history. The Museum Studies program partners with the universitys museums -- the James E. Lewis Museum of Art and the Lillie Carroll Jackson Civil Rights Museum (housed in the historic Baltimore home of civil rights leader Lillie Carroll Jackson) -- to give students hands-on training in collections care, exhibition design, and historic preservation.'),
    (5, 1, 'Philosophy and Religious Studies', 'PHIL', 'The Department of Philosophy and Religious Studies offers instruction in the history of philosophy from the ancient world to the present, in core philosophical sub-disciplines including ethics, logic, epistemology, metaphysics, and political philosophy, and in the comparative study of religious traditions. The department provides the Bachelor of Arts in Philosophy and a Philosophy minor, as well as a structured pre-law track that satisfies the analytic-reasoning, writing, and argumentation preparation recommended by the American Bar Associations Council on Legal Education. Religious-studies coursework introduces students to Christianity, Islam, Judaism, African and African-diaspora religious traditions, and the academic study of religion as a cultural and historical phenomenon. Graduates routinely enter law school, divinity school, graduate study in the humanities, and careers in public service and ethics-related professions.'),
    (6, 1, 'Political Science and International Studies', 'POSC', 'The Department of Political Science and International Studies prepares students with the analytic, research, and communication skills necessary to excel in graduate programs, law schools, and careers in government, public policy, diplomacy, and international affairs. The department offers the Bachelor of Arts in Political Science, an International Studies concentration, a Public Administration concentration, and a Pre-Law concentration, plus a minor. Curricular fields include American politics, comparative politics, international relations, political theory, and public administration and policy, with particular departmental strengths in urban politics, race and American political development, African and African-diaspora politics, and human rights. Students participate in moot court, model UN, internships in Annapolis and Washington, D.C., and faculty-led research projects, and are routinely placed in top law schools and federal-agency positions.'),
    (7, 1, 'Psychology', 'PSYC', 'The Department of Psychology is one of the largest and most research-active departments in the College of Liberal Arts. It offers the Bachelor of Science in Psychology and a Psychology minor at the undergraduate level, and at the graduate level offers a graduate certificate, the Master of Arts, and the Doctor of Philosophy in Psychometrics -- a distinctive doctoral program focused on quantitative measurement of psychological constructs, test theory, and applied data analysis that has produced a generation of measurement scientists. The undergraduate program prepares students for graduate study and for careers in human services, education, healthcare, and research, with course concentrations in clinical and counseling psychology, developmental psychology, cognitive and biological psychology, and social and community psychology. The department houses the Center for Predictive Analytics and works closely with Morgans behavioral and social-science research centers.'),
    (8, 1, 'Sociology and Anthropology', 'SOCI', 'The Department of Sociology and Anthropology offers the Bachelor of Arts in Sociology, an Anthropology track, and a sociology minor, and is one of the historic intellectual homes of social-scientific research at Morgan -- the universitys School of Social Work was originally formed in 1969 from the Undergraduate Social Welfare Program housed within this department. The departments mission is to provide its majors with the latest sociological and anthropological tools -- substantive knowledge and rigorous research methods, including statistics, ethnography, and survey research -- to enable students to positively change their environments, including their local communities, the nation, and the world. Areas of departmental strength include urban sociology, race and ethnic relations, the sociology of family, criminology, medical sociology, and the anthropology of the African diaspora. Graduates pursue careers in research, policy, social services, public health, and graduate study.'),
    (9, 1, 'World Languages and International Studies', 'WRLD', 'The Department of World Languages and International Studies is grounded in the conviction that the study of languages and cultures truly responds to national and international needs. The department offers the Bachelor of Arts in French, the Bachelor of Arts in Spanish, language minors in additional languages including Arabic and Chinese as resources permit, and an interdisciplinary International Studies concentration in cooperation with Political Science. The curriculum integrates language acquisition with literature, linguistics, civilization studies, and area studies covering Francophone Africa and the Caribbean, Latin America and the Spanish-speaking world, and broader global regions. Study-abroad programs, the Center for Global Studies and International Education, and the universitys distinguished Fulbright record (Morgan has educated more Fulbright scholars than any other HBCU) provide students with structured international experience. Graduates pursue careers in foreign service, international business, education, translation and interpretation, and graduate study.'),
    (10, 1, 'Military Science', 'MLSC', 'The Department of Military Science administers the Morgan State University / Coppin State University Army ROTC program, known as the Bear Battalion. As a college-based officer-commissioning program, Military Science trains qualifying students to become commissioned Second Lieutenants in the United States Army, Army Reserve, or Army National Guard while completing their undergraduate degrees in any major across the university. The four-year curriculum integrates classroom instruction in military leadership, ethics, military history, small-unit tactics, and national security with a parallel program of physical training, leadership labs, and field-training exercises. Cadets compete for full-tuition scholarships, summer training opportunities, and active-duty branch selection upon commissioning. Morgans ROTC program has produced nearly a dozen U.S. Army general officers, including Lieutenant General William Kip Ward, the first commanding officer of the United States Africa Command.'),

    -- SCHOOL OF ARCHITECTURE AND PLANNING
    (11, 2, 'Undergraduate Design', 'ARCH','The Department of Undergraduate Design is the undergraduate home of the School of Architecture and Planning and offers the Bachelor of Science in Architecture and Environmental Design (B.S. ARED), a pre-professional design degree that prepares students for the schools graduate professional Master of Architecture program and for related graduate study in landscape architecture, planning, interior architecture, and the building professions. The four-year curriculum is a studio-based design sequence -- introductory, intermediate, and advanced design studios with corresponding courses in architectural history, building technology, structures, environmental systems, computer-aided design and digital fabrication, professional practice, and urban-design electives. Studios emphasize the social and environmental responsibilities of design in urban contexts, with particular attention to historically underserved communities in Baltimore and the broader Mid-Atlantic. The departments studios occupy purpose-built design space in the Center for the Built Environment and Infrastructure Studies, with reviews open to practicing architects from the region.'),
    (12, 2, 'Graduate Built Environment Studies', 'BLTE', 'The Department of Graduate Built Environment Studies houses the schools three accredited professional graduate degrees -- the Master of Architecture (M.Arch) accredited by the National Architectural Accrediting Board, the Master of City and Regional Planning accredited by the Planning Accreditation Board, and the Master of Landscape Architecture accredited by the Landscape Architectural Accreditation Board -- making the School of Architecture and Planning one of the very few HBCUs to offer the full complement of accredited professional design and planning degrees. The department also offers the Doctor of Philosophy in Architecture and Built Environment, which supports research at the intersection of architecture, urban studies, environmental sustainability, and community development. Graduate students work alongside faculty on funded research through the universitys Institute for Urban Research and on community-engaged design and planning projects across Baltimore, advancing the schools mission to prepare professionals committed to equitable, sustainable, and culturally responsive built environments.'),

    -- Earl G. Graves School of Business and Management
    (13, 3, 'Accounting and Finance', 'ACCT', 'The Department of Accounting and Finance offers two distinct undergraduate degrees -- the Bachelor of Science in Accounting and the Bachelor of Science in Finance -- along with minors in each field, and contributes core coursework to the Master of Business Administration. The accounting curriculum prepares students for the Uniform CPA Examination and for careers in public accounting, corporate financial reporting, internal audit, government accounting, and forensic accounting; coursework covers financial accounting, managerial accounting, intermediate and advanced accounting, auditing, taxation, and accounting information systems. The finance curriculum prepares students for careers in corporate finance, investment management, banking, real estate, and financial planning, with concentrations in corporate finance and investment analysis and coverage of capital markets, derivatives, financial modeling, and financial econometrics. The department also collaborates with the School of Computer, Mathematical and Natural Sciences in supporting the universitys actuarial science program.'),
    (14, 3, 'Business Administration', 'BUAD', 'The Department of Business Administration is the largest department in the Earl G. Graves School and serves as the academic home for the Bachelor of Science in Business Administration with concentrations in management, marketing, entrepreneurship, supply chain management, and international business; the Master of Business Administration; and the Doctor of Philosophy in Business Administration. The undergraduate core covers principles of management, organizational behavior, principles of marketing, business law, business ethics, operations management, strategic management, and international business, providing students with both functional expertise and a broad strategic understanding of organizations. The MBA serves working professionals across the Baltimore-Washington corridor with concentrations including project management and entrepreneurship. The Ph.D. in Business Administration -- one of Morgans signature doctoral programs -- prepares scholars for academic careers and applied research in management, marketing, and organizational studies, with particular emphasis on entrepreneurship and minority business development.'),
    (15, 3, 'Information Science and Systems', 'INSS', 'The Department of Information Science and Systems offers the Bachelor of Science in Information Systems, a Bachelor of Science in Business Analytics, the Bachelor of Science in Supply Chain Management, and the Master of Science in Project Management, plus minors and graduate certificates. The undergraduate Information Systems curriculum -- ranked nationally among IS programs at HBCUs -- prepares students for careers as systems analysts, database administrators, cybersecurity analysts, business intelligence developers, and IT project managers, with required coursework in programming, database design, networks, systems analysis and design, cloud computing, and IS project development and management (the departments capstone INSS 490). The Business Analytics program develops students skills in data management, statistical analysis, machine learning for business, data visualization, and analytics for enterprises. The Supply Chain Management program covers logistics, procurement, operations, and global supply networks. INSS 141 (Digital Literacy and Application Software) is a core course taken by every student in the School of Business and Management.'),

    -- School of Community Health and Policy
    (16, 4, 'Nursing', 'NURS', 'The Department of Nursing offers the Bachelor of Science in Nursing (B.S.N.), the Master of Science in Nursing (M.S.N.) with concentrations including nurse educator and family nurse practitioner, and the Doctor of Philosophy in Nursing -- making Morgan one of the few HBCUs to offer the nursing doctorate. The B.S.N. program is accredited by the Commission on Collegiate Nursing Education and prepares graduates for licensure as registered nurses through the NCLEX-RN, with clinical rotations across Baltimore-area hospitals, community health centers, and public-health settings. Curriculum emphasizes evidence-based practice, cultural competence, population health, and the social determinants of health, with particular attention to addressing health disparities affecting urban and African American communities. The Ph.D. program prepares nurse scientists for academic and research careers focused on health-disparities research, community-based participatory research, and health-policy analysis.'),
    (17, 4, 'Public and Allied Health', 'HEED', 'The Department of Public and Allied Health is the academic home of the schools non-nursing health programs and houses three distinct programs: the Health Education program (Bachelor of Science in Health Education and Master of Public Health concentrations preparing community health educators certified through the National Commission for Health Education Credentialing), the Public Health program (Master of Public Health and Doctor of Public Health, with the Dr.P.H. one of Morgans signature applied-research doctorates focused on urban health and minority health), and the Nutritional Sciences program (Bachelor of Science in Nutritional Sciences with a Didactic Program in Dietetics accredited by the Accreditation Council for Education in Nutrition and Dietetics, preparing graduates to enter dietetic internships and pursue the Registered Dietitian Nutritionist credential). The department supports the universitys ASCEND research center on minority health and the Center for Climate Change and Health, with research portfolios spanning chronic-disease epidemiology, health communication, environmental health, food security, and community-based health interventions in Baltimore.'),

    -- School of Computer, Mathematical and Natural Sciences
    (18, 5, 'Biology', 'BIOL', 'The Department of Biology is one of Morgans largest STEM departments and offers the Bachelor of Science in Biology, the Bachelor of Science in Medical Laboratory Science (MLS) -- accredited by the National Accrediting Agency for Clinical Laboratory Sciences (NAACLS) and the American Society for Clinical Pathology (ASCP), and reporting close to 100 percent post-graduation employment within one year -- a Biology Honors Program, a Biology minor, the Master of Science in Bioinformatics, and the Doctor of Philosophy in Bioenvironmental Sciences, an applied life-sciences doctorate examining the intersection of biology, environment, and human health. Curricular concentrations span cellular and molecular biology, ecology and evolutionary biology, organismal biology and physiology, and pre-medical preparation, with required laboratory experience throughout. The department supports the Patuxent Environmental and Aquatic Research Laboratory (PEARL) on the Chesapeake Bay, the universitys Climate Science Division, and major NIH- and NSF-funded undergraduate research programs.'),
    (19, 5, 'Chemistry', 'CHEM', 'The Department of Chemistry offers the Bachelor of Science in Chemistry, a Chemistry minor, the Master of Science in Chemistry, and supports collaborative doctoral training in the chemical sciences. The undergraduate program is approved by the American Chemical Society (ACS), meaning B.S. graduates earn ACS-certified degrees recognized by graduate schools and employers nationwide. Required coursework covers general, organic, inorganic, analytical, and physical chemistry with extensive laboratory experience, plus electives in biochemistry, instrumental analysis, and computational chemistry. Faculty research areas include synthetic organic and medicinal chemistry, materials chemistry, environmental chemistry, computational and theoretical chemistry, and chemical education, with externally funded grants from the National Institutes of Health, the National Science Foundation, and the Department of Defense. The department serves as a primary feeder of African American chemists into doctoral programs and the pharmaceutical, biotechnology, and chemical industries.'),
    (20, 5, 'Computer Science', 'COSC', 'The Department of Computer Science -- headquartered in McMechen Hall -- offers the Bachelor of Science in Computer Science (ABET-accredited by the Computing Accreditation Commission), the Bachelor of Science in Cloud Computing, a Computer Science minor, the Master of Science in Advanced Computing, and the Doctor of Philosophy in Computer Science. The undergraduate curriculum centers on a core sequence (COSC 111 / 112 / 220 / 281 / 241 / 351 / 354 / 458 / 491) covering programming, computer systems, data structures, discrete structures, databases, operating systems, software engineering, and a senior capstone, with electives in cybersecurity, artificial intelligence, machine learning, networking, computer graphics, and game design. The department maintains active collaborations with Google, Meta, JPMorgan Chase, NASA, NSA, and Lockheed Martin, supports the Society for the Advancement of Computer Science (SACS) student club founded in 1964, and is home to a Department of Defense Center of Academic Excellence in Cyber Defense.'),
    (21, 5, 'Mathematics', 'MATH', 'The Department of Mathematics offers the Bachelor of Science in Mathematics, a Mathematics Honors Program, the Bachelor of Science in Actuarial Science (a distinctive interdisciplinary program with Accounting, Finance, and Economics that prepares students for the Society of Actuaries / Casualty Actuarial Society professional examinations), Mathematics minors in general and statistics tracks, an Actuarial Science minor, and the Master of Science in Mathematics. Undergraduate coursework spans the calculus sequence (MATH 241 / 242 / 243), linear algebra, abstract algebra, real and complex analysis, differential equations, numerical methods, probability and statistics, and applied mathematics electives. The department hosts the Summer Academy of Actuarial and Mathematical Sciences (SAAMS) for high school students, the Center for Excellence in Mathematics and Science, and faculty research in combinatorics, mathematical biology, statistics, and mathematics education.'),
    (22, 5, 'Physics and Engineering Physics', 'PHYS', 'The Department of Physics and Engineering Physics offers the Bachelor of Science in Physics, the Bachelor of Science in Engineering Physics (a distinctive program combining a physics core with engineering coursework, particularly suited to students interested in applied physics, electro-optics, and the physics of devices), Physics and Engineering Physics minors, and graduate study in physics. Required coursework covers classical mechanics, electromagnetism, thermodynamics and statistical mechanics, quantum mechanics, modern physics, and laboratory physics, plus an upper-division research or design experience. The department is home to the Department of Defense (DOD) Center of Excellence in Research and Education at Morgan, with funded research in optics, photonics, nanomaterials, atomic and molecular physics, and astrophysics. The department is the principal academic home of physics teaching for the universitys engineering students and contributes substantially to the Engineering Physics 3-2 program.'),

    -- School of Education and Urban Studies
    (23, 6, 'Advanced Studies, Leadership, and Policy', 'ASLP', 'The Department of Advanced Studies, Leadership, and Policy is the graduate-only department of the School of Education and Urban Studies and houses Morgans graduate programs in higher education, educational leadership, school counseling, and educational policy. Programs include the Master of Education (M.Ed.) in Higher Education Administration; the Master of Education in Community College Administration, Instruction, and Student Development; the Master of Education in School Counseling; advanced certificates in school leadership; and the Doctor of Education (Ed.D.) in Urban Educational Leadership and the Doctor of Philosophy in Urban Educational Leadership -- doctoral programs designed for working educators and administrators committed to leading equity-focused change in K-12 schools, community colleges, and urban universities. The department is closely tied to the National Center for the Elimination of Educational Disparities and supports applied research on urban schools, college access and success, and education policy.'),
    (24, 6, 'Family and Consumer Sciences', 'FACS', 'The Department of Family and Consumer Sciences (FCS) is the academic home of two distinctive applied programs that bridge the human sciences and the service economy: the Bachelor of Science in Family and Consumer Sciences with a Child and Family Development concentration that prepares students for early-childhood program leadership, family-resource-management careers, and graduate study in human development; and the Bachelor of Science in Hospitality Management, accredited by the Accreditation Commission for Programs in Hospitality Administration (ACPHA), preparing students for management careers in hotels, restaurants, food-service organizations, event management, and tourism. Curriculum integrates core business and management coursework with hospitality-specific subjects -- food and beverage operations, lodging operations, hospitality marketing, and revenue management -- and includes required industry internships. FCS also supports universitywide instruction in nutrition, child development, and consumer education.'),
    (25, 6, 'Teacher Education and Professional Development', 'TEPD', 'The Department of Teacher Education and Professional Development is the principal teacher-preparation unit of the university and prepares Maryland-certified teachers across the spectrum from early childhood through secondary content areas. Bachelor of Science programs include Elementary Education, Early Childhood Education, Secondary English Education, Secondary Mathematics Education, Secondary Social Studies Education, and Secondary Science Education (with subject-area partners in the relevant content departments), as well as Special Education. Graduate programs include the Master of Arts in Teaching (M.A.T.) for career-changers seeking initial certification and graduate degrees for in-service teachers. All initial-certification programs are approved by the Maryland State Department of Education and are nationally recognized through Council for the Accreditation of Educator Preparation (CAEP) accreditation. Candidates complete extensive field experience and a yearlong professional internship in partner schools across Baltimore City and surrounding districts.'),

    -- Clarence M. Mitchell, Jr. School of Engineering
    (26, 7, 'Civil and Environmental Engineering', 'CEGR', 'The Department of Civil and Environmental Engineering offers the Bachelor of Science in Civil Engineering (ABET-accredited), the Master of Engineering and Master of Science in Civil Engineering, and the Doctor of Engineering and Doctor of Philosophy in Civil Engineering. The undergraduate program covers the principal civil-engineering subdisciplines -- structural engineering, geotechnical engineering, transportation engineering, environmental and water-resources engineering, and construction engineering -- with a required engineering-design capstone. The department maintains structural, geotechnical, environmental, and transportation laboratories and is closely linked to the universitys National Transportation Center and the Center for Advanced Transportation and Infrastructure Engineering Research, attracting funded research from the U.S. Department of Transportation and the Maryland State Highway Administration. Graduates take positions with state and federal transportation agencies, consulting engineering firms, and the construction industry.'),
    (27, 7, 'Electrical and Computer Engineering', 'EEGR', 'The Department of Electrical and Computer Engineering offers the Bachelor of Science in Electrical Engineering (ABET-accredited), the Master of Engineering and Master of Science in Electrical Engineering, and the Doctor of Engineering and Doctor of Philosophy in Electrical Engineering. The undergraduate curriculum covers circuit analysis (EEGR 202), digital logic design (EEGR 281), electromagnetics, signals and systems, electronics, communications, control systems, computer architecture, and microprocessors, with technical elective concentrations in communications and signal processing, computer engineering, control systems, and electromagnetics and photonics. The department is home to substantial federally funded research, including projects with NASA, the Department of Defense, and the National Science Foundation, and operates research centers in cybersecurity, communications, and microelectronics. Graduates go to industry roles at major defense, telecommunications, and semiconductor employers and to top-ranked engineering Ph.D. programs.'),
    (28, 7, 'Industrial and Systems Engineering', 'IEGR', 'The Department of Industrial and Systems Engineering offers the Bachelor of Science in Industrial Engineering (ABET-accredited), the Master of Engineering in Industrial and Systems Engineering, and the Doctor of Engineering in Industrial and Systems Engineering. The discipline studies how complex systems of people, equipment, materials, information, and energy can be designed and managed for effectiveness and efficiency. Required coursework includes engineering economy, probability and statistics for engineers, operations research (linear, integer, and nonlinear programming), simulation, work design and ergonomics, quality engineering, supply-chain engineering, and a senior capstone. The department maintains laboratories in human factors and ergonomics, simulation, and quality engineering, and partners with regional manufacturers, healthcare systems, and federal agencies on systems-improvement projects. Graduates take roles in manufacturing, healthcare-systems engineering, logistics and supply chains, consulting, and government.'),
    (29, 7, 'Construction Management', 'CMGT', 'The Department of Construction Management offers the Bachelor of Science in Construction Management, an applied program preparing graduates for managerial careers in the construction industry. The curriculum integrates construction-specific coursework -- construction methods and materials, construction estimating, construction scheduling and project controls, construction safety, construction law and contracts, construction accounting and finance, and a capstone -- with foundational engineering science, architecture, and business coursework. Students develop fluency with industry-standard software for cost estimating, scheduling, and Building Information Modeling (BIM). The program is accredited by the American Council for Construction Education (ACCE) and includes required internships with regional construction firms. The department prepares students for the Associate Constructor and Certified Professional Constructor examinations administered by the American Institute of Constructors and supplies a steady pipeline of construction managers to general contractors, public agencies, and specialty subcontractors across the Baltimore-Washington corridor.'),
    (30, 7, 'Transportation and Urban Infrastructure Studies', 'TRSU', 'The Department of Transportation and Urban Infrastructure Studies (TUIS) is the graduate-only transportation department of the School of Engineering and offers the Master of Science and Doctor of Philosophy in Transportation, two of the longest-running and most distinguished transportation graduate programs at any HBCU. The department is the academic home of Morgans federally designated National Transportation Center -- one of the U.S. Department of Transportation University Transportation Centers -- which has, for several decades, conducted federally funded research on freight transportation, transportation safety, public transit, intelligent transportation systems, and transportation equity. Curriculum covers transportation planning, traffic engineering and operations, public-transit planning and operations, freight and logistics, transportation safety and security, intelligent transportation systems, and transportation economics and policy. The department prepares transportation researchers, planners, and engineers for federal and state transportation agencies, metropolitan planning organizations, consulting firms, and academic positions.'),

    -- School of Global Journalism and Communication
    (31, 8, 'Multimedia Journalism', 'MMJO', 'The Department of Multimedia Journalism offers the Bachelor of Science in Multimedia Journalism, a degree designed for the converged media environment in which print, broadcast, and digital storytelling have collapsed into a single multimedia practice. The curriculum integrates writing and reporting (news writing, beat reporting, investigative reporting, magazine journalism), visual storytelling (photojournalism, video journalism, data visualization), production craft (audio, video, web), and the institutional context of journalism (media law, media ethics, the history of African American journalism, global journalism). Students complete a capstone reporting project and required internships, with placements at the Baltimore Sun, the Baltimore Banner, regional television and radio stations, national news organizations, and the universitys WEAA 88.9 FM and student newspaper. The departments alumni include New York Times sports columnist William C. Rhoden and a generation of Black journalists in print, broadcast, and digital media.'),
    (32, 8, 'Multiplatform Production', 'MPPR', 'The Department of Multiplatform Production offers the Bachelor of Science in Multiplatform Production, a production-focused degree preparing students to write, produce, direct, edit, and distribute media across television, film, streaming, podcast, web, and emerging platforms. The curriculum is built around hands-on production sequences -- video production, audio production, postproduction and editing, motion graphics and visual effects, podcasting, and web production -- combined with coursework in story development, screenwriting, media business, and entrepreneurship for content creators. Students work in the Communications Center production studios, edit suites, and audio booths, and produce content for distribution through the universitys WEAA 88.9 FM, the student newspaper, and national platforms. Graduates pursue careers as producers, editors, content creators, podcasters, and post-production professionals at national networks, streaming services, and independent production companies, and a number have founded their own production studios.'),
    (33, 8, 'Strategic Communication', 'SCOM', 'The Department of Strategic Communication offers the Bachelor of Science in Strategic Communication, a degree integrating the historically separate disciplines of public relations, advertising, brand strategy, organizational communication, and political and advocacy communication into a unified strategic-communication practice. The curriculum covers strategic-communication writing, audience research and analytics, campaign planning, public-relations management, advertising and brand strategy, social-media strategy, crisis communication, and a capstone strategic-communication campaign in which students develop full client deliverables. Students compete in national strategic-communication competitions, including those of the Public Relations Student Society of America (PRSSA) and the National Student Advertising Competition. Required internships are placed with public-relations and advertising agencies, corporations, non-profits, and political and advocacy organizations across the Baltimore-Washington corridor. Graduates take positions in agency PR, corporate communications, political and advocacy communication, and digital and social-media strategy.'),

    -- School of Social Work
    (34, 9, 'Social Work', 'SOWK', 'The Department of Social Work is the sole academic department of the School of Social Work and offers the Bachelor of Social Work (B.S.W.), the Master of Social Work (M.S.W.), and the Doctor of Philosophy in Social Work -- a comprehensive vertical curriculum accredited by the Council on Social Work Education (CSWE). The B.S.W. prepares generalist social-work practitioners and licensed bachelor-level social workers; the M.S.W. is offered with concentrations in clinical / direct practice and in macro / community-and-administrative practice and prepares graduates for licensed master-level and licensed clinical social-work practice; and the Ph.D. prepares social-work scholars and educators with expertise in urban, African American, and minority-community practice and policy. The school emphasizes anti-oppressive, culturally responsive, and community-engaged practice with particular attention to mental and behavioral health, child welfare, aging, criminal-justice-involved populations, and health-disparities populations. All programs require extensive supervised field placements with social-service agencies, hospitals, schools, and community-based organizations across the Baltimore region.'),

    -- College of Interdisciplinary and Continuing Studies
    (35, 10, 'Interdisciplinary and Continuing Studies', 'INDS', 'The Department of Interdisciplinary and Continuing Studies houses the Bachelor of Science in Applied Liberal Studies and a portfolio of certificates and online and accelerated programs designed for non-traditional learners. Applied Liberal Studies is a customizable interdisciplinary degree-completion program intended for transfer students, working adults, and military-affiliated students with prior college credit; students design a personalized plan of study integrating two or more disciplinary concentrations drawn from across the university (for example, leadership and organizational studies; health and human services; computing and applied technology; communication and media; and African and African American studies) under the guidance of a faculty advisor and culminating in a capstone integrative project. The department also coordinates the universitys Center for Continuing and Professional Studies, which delivers non-credit professional certificates, workforce-development programs, and lifelong-learning offerings to adult learners across the Baltimore-Washington region.');

-- ---------------------------------------------------------------------------
-- COURSES  (real Morgan State catalog codes from catalog.morgan.edu)
-- ---------------------------------------------------------------------------
-- Computer Science (dept 20, code COSC)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (1, 20, 'Introduction to Computer Science I',      'COSC 111', 100, 3, 'A general-education computing course introducing students to the use of computers, productivity software, the Internet, and basic problem-solving techniques. Topics include hardware and software fundamentals, operating systems, word processing, spreadsheets, presentations, databases, and an introduction to algorithmic thinking. Required of students in many non-CS majors as a Mathematics and Quantitative Reasoning option. Offered Fall, Spring, and Summer.'),
    (2, 20, 'Introduction to Computer Science II',     'COSC 112', 100, 4, 'First course in the two-semester sequence for computer science majors. Topics include programming fundamentals, problem solving, control structures, functions, lists and tuples, file input and output, and an introduction to classes and objects in a high-level language. Three lecture hours and one lab hour weekly. Programming labs reinforce lecture topics through hands-on assignments. Offered Fall and Spring.'),
    (3, 20, 'Introduction to Computer Science III',    'COSC 150', 100, 4, 'Second course in the CS major sequence. Continues from COSC 112 and covers simple data structures (lists, tuples, dictionaries), modules, string handling, file I/O, exception handling, recursion, and an introduction to classes and objects. Programming labs require students to compile and execute larger programs using standard editors. Three lecture hours and one lab hour. Prerequisite: COSC 112 with a grade of C or better.'),
    (4, 20, 'Computer Science and Data Analysis',      'COSC 201', 200, 3, 'Service course introducing computational thinking and data analysis to non-CS majors. Topics include data manipulation, basic statistical reasoning with code, simple visualization, and use of computational tools for evidence-based reasoning in the social and natural sciences. Counts as a Mathematics and Quantitative Reasoning general-education option. No prior programming experience required.'),
    (5, 20, 'Data Structures and Algorithms',          'COSC 220', 200, 4, 'Data Structures and Algorithms. Fundamental data structures and the algorithms that act on them: strings, lists, arrays, stacks, queues, dictionaries, maps, trees, and graphs. Insertion, deletion, traversal, searching, and sorting algorithms with corresponding time and space complexity analysis. Three lecture hours and one lab hour. Prerequisite: COSC 112 with a grade of C or better. Offered Fall and Spring.'),
    (6, 20, 'Advanced Programming',                    'COSC 237', 200, 3, 'Advanced programming techniques building on the introductory CS sequence. Topics include advanced control structures, modular design, defensive programming, debugging strategies, performance considerations, and integration of multiple data sources. Programming projects emphasize code quality and maintainability. Prerequisite: COSC 150.'),
    (7, 20, 'Object-Oriented Programming',             'COSC 238', 200, 4, 'Fundamental concepts of object-oriented programming -- abstraction, encapsulation, inheritance, and polymorphism -- through classes, objects, and dynamic data structures in an object-oriented language. Coverage of object-oriented analysis and design (OOAD) using UML. Four lecture hours per week. Prerequisite: COSC 112.'),
    (8, 20, 'Java Programming',                        'COSC 239', 200, 3, 'Java syntax and program structure, objects and classes, introductory data structures in Java, annotations and self-documentation, programming practices, software development principles, graphical user interfaces, and hands-on programming practice. Designed for students who already have foundational programming experience. Three lecture hours per week.'),
    (9, 20, 'Computer Organization',                   'COSC 241', 200, 3, 'Discrete Structures. Logic, sets, relations, functions, induction, combinatorics, recurrence relations, and graph theory with emphasis on applications to computing. Proof techniques used throughout the upper-division CS curriculum are introduced and practiced. Required preparation for COSC 281 and most upper-division theoretical courses.'),
    (10, 20, 'Computer Architecture',                   'COSC 243', 200, 3, 'Introduction to computer organization and architecture. The computer is described as a hierarchy of levels each performing a well-defined function, with comparisons across implementations in different systems. Topics include CPU organization and control, instruction set architecture, memory organization, and I/O structure. Three lecture hours. Prerequisite: COSC 112.'),
    (11, 20, 'Introduction to Data Science',            'COSC 251', 200, 3, 'Introduction to using computers for analysis, interpretation, and visualization of structured and unstructured data from varying sources. Topics include data analysis, modeling, data mining, data visualization, and basic search techniques. Hands-on assignments with real datasets. Three lecture hours.'),
    (12, 20, 'Discrete Structures',                     'COSC 281', 200, 3, 'Discrete mathematics for computing. Set theory, propositional and predicate logic, relations and functions, mathematical induction, counting techniques, recurrence relations, basic graph theory, and trees, with applications throughout computer science. Builds the proof-writing foundation required for theory courses and algorithm analysis. Three lecture hours.'),
    (13, 20, 'Algorithm Design and Analysis',           'COSC 320', 300, 3, 'Design and analysis of algorithms. Asymptotic notation, divide-and-conquer, greedy algorithms, dynamic programming, graph algorithms, and an introduction to NP-completeness. Algorithm correctness proofs and worst-case running-time analysis. Three lecture hours. Prerequisite: COSC 220 with a grade of C or better.'),
    (14, 20, 'Introduction to Cryptography',            'COSC 323', 300, 3, 'Mathematical foundations and practical use of cryptography. Classical ciphers, symmetric-key cryptography (DES, AES), public-key cryptography (RSA, Diffie-Hellman), hash functions, digital signatures, key management, and applications in network security. Three lecture hours. Prerequisite: COSC 281.'),
    (15, 20, 'Introduction to Game Design and Development', 'COSC 332', 300, 3, 'Principles of game design including game mechanics, level design, narrative, art and audio integration, and playtesting, paired with hands-on development using a modern game engine. Students design, prototype, and ship a small original game over the term. Three lecture hours. Prerequisite: COSC 220.'),
    (16, 20, 'Mobile App Design and Development',       'COSC 338', 300, 3, 'Design and development of applications for modern mobile platforms. UI/UX patterns, device sensors, networking, persistence, and platform-specific deployment. Students design, build, and publish a working mobile application as a course project. Three lecture hours. Prerequisite: COSC 220.'),
    (17, 20, 'Introduction to High-Performance Computing', 'COSC 345', 300, 3, 'Fundamentals of high-performance and parallel computing. Multicore architectures, shared- and distributed-memory parallel programming (OpenMP and MPI), GPU computing, performance analysis, and scientific applications. Programming projects on departmental and shared computing resources. Three lecture hours. Prerequisite: COSC 220.'),
    (18, 20, 'Computer Networks',                       'COSC 349', 300, 3, 'Introduction to data communications and computer networks. Layered protocols, the Internet protocol stack, link, network, transport, and application layers, routing, congestion control, and an introduction to network security. Hands-on exercises with packet analysis and socket programming. Three lecture hours. Prerequisite: COSC 220.'),
    (19, 20, 'Foundations of Computing, Security, and Information Assurance', 'COSC 350', 300, 3, 'Foundational concepts in cybersecurity and information assurance. Security principles, risk management, access control, threat modeling, common vulnerabilities and attacks, basic cryptography, and security policies. Designed as a gateway course into the cybersecurity track. Three lecture hours. Prerequisite: COSC 220.'),
    (20, 20, 'Cybersecurity',                           'COSC 351', 300, 3, 'Practical cybersecurity. Network security, system hardening, web application security, malware analysis, intrusion detection, incident response, and ethical and legal aspects of cybersecurity practice. Hands-on labs in a controlled environment. Three lecture hours. Prerequisite: COSC 350 or instructor permission.'),
    (21, 20, 'Organization of Programming Languages',   'COSC 352', 300, 3, 'Comparative study of programming-language paradigms: imperative, object-oriented, functional, and logic programming. Syntax and semantics, type systems, scoping, parameter passing, control structures, and language implementation. Programming exercises in multiple languages illustrate paradigm differences. Three lecture hours. Prerequisite: COSC 220.'),
    (22, 20, 'Major Operating Systems',                 'COSC 353', 300, 3, 'Survey of major modern operating systems. Comparative architecture of UNIX/Linux, Windows, and other current systems. Process management, memory management, file systems, and security as implemented in each. Three lecture hours. Prerequisite: COSC 220.'),
    (23, 20, 'Operating Systems',                       'COSC 354', 300, 3, 'Principles of operating-system design and implementation. Processes and threads, scheduling, synchronization, deadlock, memory management and virtual memory, file systems, I/O, protection, and an introduction to distributed systems. Programming projects extending a teaching operating system. Three lecture hours. Prerequisite: COSC 220.'),
    (24, 20, 'Compilers',                               'COSC 356', 300, 3, 'Design and implementation of compilers. Lexical analysis, parsing (top-down and bottom-up), syntax-directed translation, intermediate representations, semantic analysis, code generation, and basic optimization. Students build a working compiler for a small source language over the term. Three lecture hours. Prerequisite: COSC 281, COSC 220.'),
    (25, 20, 'Network Security Fundamentals',           'COSC 358', 300, 3, 'Network security principles and applications: authentication, IP security, web security, network management security, wireless security, and system security. Hands-on labs reinforce defensive and analytical techniques. Three lecture hours. Prerequisite: COSC 349 or COSC 350.'),
    (26, 20, 'Database Design',                         'COSC 359', 300, 3, 'Functions of a database system, data modeling, and logical database design. Tuples, relations, attributes, keys, relationships, E-R diagrams, normalization, ACID properties, query languages (SQL and NoSQL), query processing and optimization, efficient data storage and access, concurrency control, and recovery. Three lecture hours. Prerequisite: COSC 220.'),
    (27, 20, 'Numerical Methods and Programming',       'COSC 383', 300, 3, 'Numerical methods for scientific computing: error analysis, root finding, systems of linear equations, interpolation, numerical integration and differentiation, and numerical solutions of ordinary differential equations. Programming projects implement methods and analyze results. Three lecture hours. Prerequisite: MATH 242 and COSC 220.'),
    (28, 20, 'Theory of Languages and Automata',        'COSC 385', 300, 3, 'Formal languages and machines. Finite automata and regular languages, context-free grammars and pushdown automata, Turing machines, decidability, and an introduction to computational complexity. Three lecture hours. Prerequisite: COSC 281.'),
    (29, 20, 'Conference Course',                       'COSC 391', 300, 3, 'Special-topics conference course. Areas of study are determined each semester by the instructor and announced in advance. Topics rotate among current areas of computer science not regularly covered in the curriculum. Three lecture hours. Prerequisite: instructor permission.'),
    (30, 20, 'Parallel Algorithms',                     'COSC 458', 400, 3, 'Software Engineering. Software development life-cycle models, requirements engineering, software architecture and design patterns, software testing and verification, version control and continuous integration, and team-based software projects. Group projects with deliverables modeled on industry practice. Three lecture hours. Prerequisite: COSC 220.'),
    (31, 20, 'Database Design',                         'COSC 459', 400, 3, 'Advanced database design and implementation. Advanced relational design, query optimization internals, transaction management, distributed databases, and NoSQL systems. Project work covers schema design, query tuning, and a full database application. Three lecture hours. Prerequisite: COSC 220.'),
    (32, 20, 'Computer Graphics',                       'COSC 460', 400, 3, 'Principles and practice of computer graphics. Geometric transformations, viewing and projection, rasterization, shading, texture mapping, and an introduction to GPU programming with modern graphics APIs. Programming projects build interactive 2D and 3D graphics applications. Three lecture hours. Prerequisite: COSC 220 and MATH 312.'),
    (33, 20, 'Artificial Intelligence',                 'COSC 470', 400, 3, 'Introduction to artificial intelligence. Search and problem-solving, knowledge representation, logical and probabilistic reasoning, planning, an introduction to machine learning, and ethical considerations in AI. Programming assignments implement core AI techniques. Three lecture hours. Prerequisite: COSC 220.'),
    (34, 20, 'Introduction to Machine Learning',        'COSC 472', 400, 3, 'Introduction to machine learning. Supervised learning (linear regression, logistic regression, decision trees, support vector machines, neural networks), unsupervised learning (clustering, dimensionality reduction), evaluation methodology, and applications. Programming projects use modern ML libraries. Three lecture hours. Prerequisite: COSC 220 and MATH 331.'),
    (35, 20, 'Introduction to Image Processing and Analysis', 'COSC 480', 400, 3, 'Digital image processing and analysis. Image representation, point and neighborhood operations, image enhancement, restoration, segmentation, morphology, feature extraction, and an introduction to computer vision. Programming projects implement core algorithms. Three lecture hours. Prerequisite: COSC 220 and MATH 312.'),
    (36, 20, 'Applied Quantum Computing',               'COSC 486', 400, 3, 'Introduction to quantum computing for computer scientists. Qubits, quantum gates and circuits, quantum algorithms (Deutsch-Jozsa, Grover, Shor), quantum error correction at an introductory level, and hands-on programming with a modern quantum SDK. Three lecture hours. Prerequisite: COSC 281 and MATH 312.'),
    (37, 20, 'Senior Project',                          'COSC 490', 400, 3, 'Capstone senior design project. Working in teams under faculty supervision, students plan, design, implement, document, and present a substantial software project that integrates content from across the CS curriculum. Three credit hours; counts toward the senior comprehensive requirement. Prerequisite: senior standing and COSC 458.'),
    (38, 20, 'Senior Project (Continuation)',           'COSC 491', 400, 3, 'Continuation of the senior capstone. Teams complete implementation, testing, deployment, and final presentation of the project begun in COSC 490. Required for graduation in computer science. Prerequisite: COSC 490.'),
    (39, 20, 'Conference Course',                       'COSC 498', 400, 3, 'Senior-level conference course on special topics in computer science. Topics rotate by semester and instructor and are announced in advance. Three lecture hours. Prerequisite: senior standing and instructor permission.'),
    (40, 20, 'Senior Internship',                       'COSC 499', 400, 3, 'Supervised industry internship for senior CS majors. Students work in a vetted industry placement applying their CS coursework to a substantial professional project, write a structured reflection paper, and present results. Prerequisite: senior standing, faculty approval, and an approved internship offer.');

-- Mathematics (dept 21, code MATH)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (41, 21, 'Mathematics for Liberal Arts',            'MATH 109', 100, 4, 'General-education quantitative-reasoning course for liberal-arts majors. Topics include arithmetic and algebraic reasoning, basic probability, descriptive statistics, financial mathematics, and modeling with functions. Designed to satisfy the Mathematics and Quantitative Reasoning general-education requirement for students whose majors do not require calculus.'),
    (42, 21, 'Algebra, Functions, and Analytic Geometry', 'MATH 110', 100, 3, 'College algebra. Real numbers, equations and inequalities, polynomial and rational functions, exponential and logarithmic functions, systems of equations, and an introduction to analytic geometry. Preparation for MATH 113 and the calculus sequence. Three credit hours.'),
    (43, 21, 'Introduction to Mathematical Analysis I', 'MATH 113', 100, 4, 'First half of a unified course in algebra, trigonometry, and analytic geometry. Topics include fundamentals of algebra, functions and graphs, exponential and logarithmic functions, analytic geometry, and an introduction to the conic sections. Four credit hours, four lecture hours weekly. Offered Fall and Spring.'),
    (44, 21, 'Introduction to Mathematical Analysis II','MATH 114', 100, 4, 'Continuation of MATH 113. Trigonometric functions, identities, and equations, vectors and the law of cosines, polar coordinates and complex numbers, and additional topics in analytic geometry. Prepares students for MATH 241. Four credit hours. Prerequisite: MATH 113.'),
    (45, 21, 'Finite Mathematics',                      'MATH 118', 100, 3, 'Finite mathematical methods for business, social science, and life-science majors. Linear equations and inequalities, matrices, linear programming, basic probability and counting techniques, and the mathematics of finance. Three credit hours.'),
    (46, 21, 'Introduction to Probability and Decision Making', 'MATH 120', 100, 3, 'First course in probability theory for students with limited mathematical background. Probability rules, discrete and continuous random variables, expectation, and basic statistical decision making. Designed for majors in psychology, sociology, biology, chemistry, physics, business, political science, and mathematics. Three credit hours.'),
    (47, 21, 'Mathematical Logic I',                    'MATH 215', 200, 3, 'First semester of a two-semester course in mathematical logic. Propositional and predicate logic, formal proof techniques (direct, contrapositive, contradiction, induction), set theory, and elementary number theory, with emphasis on the writing of rigorous proofs. Required preparation for upper-division proof-based mathematics courses.'),
    (48, 21, 'Mathematical Logic II',                   'MATH 216', 200, 3, 'Continuation of MATH 215. Functions, relations, equivalence and order, cardinality, and an introduction to abstract structures. Continued emphasis on proof writing across a wider variety of mathematical contexts. Prerequisite: MATH 215.'),
    (49, 21, 'Calculus I',                              'MATH 241', 200, 4, 'First course in calculus. Limits, continuity, derivatives, applications of differentiation, the definite integral, and the Fundamental Theorem of Calculus. Four credit hours, four lecture hours weekly. Prerequisite: MATH 114 or placement.'),
    (50, 21, 'Calculus II',                             'MATH 242', 200, 4, 'Second course in calculus. Techniques and applications of integration, sequences and series, Taylor series, parametric equations, and polar coordinates. Four credit hours, four lecture hours weekly. Prerequisite: MATH 241 with a grade of C or better.'),
    (51, 21, 'Calculus III',                            'MATH 243', 200, 4, 'Multivariable calculus. Vectors and analytic geometry in three dimensions, partial derivatives, multiple integrals, line and surface integrals, and the theorems of Green, Stokes, and Gauss. Four credit hours. Prerequisite: MATH 242 with a grade of C or better.'),
    (52, 21, 'Linear Algebra I',                        'MATH 312', 300, 3, 'Vector spaces, linear transformations and matrices, systems of linear equations, determinants, eigenvalues and eigenvectors, and canonical forms. Additional topics included as time permits. Three credit hours. Prerequisite: MATH 242.'),
    (53, 21, 'Modern Algebra',                          'MATH 313', 300, 3, 'Introduction to abstract algebra. Groups, subgroups, normal subgroups, quotient groups, homomorphisms, rings, ideals, and integral domains, with selected examples drawn from number theory and geometry. Three credit hours. Prerequisite: MATH 216 and MATH 312.'),
    (54, 21, 'Differential Equations',                  'MATH 340', 300, 3, 'Ordinary differential equations. First-order equations, linear higher-order equations, systems of linear differential equations, Laplace transforms, series solutions, and applications to physics, engineering, and the life sciences. Three credit hours. Prerequisite: MATH 242.'),
    (55, 21, 'Probability and Statistics',              'MATH 331', 300, 3, 'Calculus-based introduction to probability and inferential statistics. Probability rules, random variables and distributions, expectation and variance, the central limit theorem, point and interval estimation, and hypothesis testing. Three credit hours. Prerequisite: MATH 242.'),
    (56, 21, 'Actuarial and Stochastic Models I',       'MATH 364', 300, 3, 'First course in actuarial mathematical models. Probability models for insurance and finance, survival distributions, life tables, life insurance and annuity present-value models, and net premium calculation. Three credit hours. Prerequisite: MATH 331.'),
    (57, 21, 'Actuarial and Stochastic Models II',      'MATH 371', 300, 3, 'Continuation of MATH 364. Reserves, multiple-life and multiple-decrement models, pension mathematics, and additional topics in stochastic models for actuarial practice. Prepares students for the relevant SOA/CAS preliminary examinations. Three credit hours. Prerequisite: MATH 364.'),
    (58, 21, 'Real Analysis I',                         'MATH 411', 400, 3, 'Rigorous treatment of single-variable analysis. The real number system, sequences and series, continuity, differentiation, Riemann integration, and uniform convergence, with full proofs throughout. Three credit hours. Prerequisite: MATH 243 and MATH 216.'),
    (59, 21, 'Numerical Analysis',                      'MATH 415', 400, 3, 'Numerical methods and their analysis. Floating-point arithmetic and error, root finding, interpolation, numerical integration and differentiation, numerical linear algebra, and numerical solutions of ordinary differential equations. Programming exercises in a modern numerical environment. Three credit hours. Prerequisite: MATH 312, MATH 340.'),
    (60, 21, 'Senior Project',                          'MATH 491', 400, 3, 'Capstone senior project for mathematics majors. Independent investigation of a mathematical topic under faculty supervision, culminating in a written thesis and oral presentation. Required for graduation. Three credit hours. Prerequisite: senior standing.');

-- English (dept 2, code ENGL)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (61, 2, 'Reading and Writing I',                    'ENGL 101', 100, 3, 'First-semester freshman composition. Develops the students command of English as an instrument of learning and expression, with emphasis on essay writing, critical reading, and rhetorical analysis. Required of all undergraduates as a foundation for college-level writing across the curriculum. Three lecture hours. Offered Fall, Spring, and Summer.'),
    (62, 2, 'Reading and Writing II',                   'ENGL 102', 100, 3, 'Continuation of ENGL 101. Research-based writing and argumentation, focusing on source evaluation, integration of evidence, and the writing of a substantial researched argumentative essay. Required of all undergraduates. Three lecture hours. Prerequisite: ENGL 101 with a grade of C or better.'),
    (63, 2, 'Reading and Writing I -- Honors',          'ENGL 111', 100, 3, 'Honors first-semester composition. Develops command of language as an instrument of learning and expression with extensive reading and critical thinking in support of advanced writing skills. Required of students in the University Honors Program; open to other students with departmental permission. Three lecture hours.'),
    (64, 2, 'Reading and Writing II -- Honors',         'ENGL 112', 100, 3, 'Continuation of ENGL 111 for Honors students. Research-based writing and argumentation at the Honors level. Prerequisite: ENGL 111 or instructor permission. Three lecture hours.'),
    (65, 2, 'World Literature',                         'ENGL 201', 200, 3, 'Survey of major works of world literature read in English translation. Texts drawn from the literary traditions of Africa, Asia, the Americas, and Europe, with attention to historical and cultural context. Counts toward humanities general-education requirements. Three lecture hours.'),
    (66, 2, 'Introduction to Literature',               'ENGL 202', 200, 3, 'Introduction to the close reading of poetry, fiction, and drama. Students learn the vocabulary of literary analysis and write short critical essays on representative works. Three lecture hours.'),
    (67, 2, 'Survey of African American Literature',    'ENGL 207', 200, 3, 'Survey of African American literature from its origins to the present. Slave narratives, the Harlem Renaissance, mid-century realism, the Black Arts Movement, and contemporary writing, with attention to historical and political context. Three lecture hours.'),
    (68, 2, 'Introduction to Creative Writing',         'ENGL 250', 200, 3, 'Introduction to creative writing in poetry, fiction, and creative nonfiction. Workshop format with regular peer review and revision. Required of creative writing track students. Three lecture hours. Prerequisite: ENGL 102.'),
    (69, 2, 'Survey of British Literature I',           'ENGL 301', 300, 3, 'British literature from Anglo-Saxon origins through the eighteenth century. Major authors include Chaucer, Shakespeare, Milton, and Pope, read alongside selected anonymous and lesser-known works. Three lecture hours. Prerequisite: ENGL 102.'),
    (70, 2, 'Survey of British Literature II',          'ENGL 302', 300, 3, 'British literature from the Romantic period to the present. Romantic, Victorian, and modernist writers, postwar British and Anglophone fiction, and contemporary poetry. Three lecture hours. Prerequisite: ENGL 102.'),
    (71, 2, 'American Literature I',                    'ENGL 311', 300, 3, 'American literature from the colonial period through the Civil War. Puritan writing, the early national period, Transcendentalism, and antebellum fiction, poetry, and oratory, with attention to questions of race, region, and national identity. Three lecture hours. Prerequisite: ENGL 102.'),
    (72, 2, 'American Literature II',                   'ENGL 312', 300, 3, 'American literature from Reconstruction to the present. Realism and naturalism, modernism, the Harlem Renaissance, postwar fiction, and contemporary writing. Three lecture hours. Prerequisite: ENGL 102.'),
    (73, 2, 'African American Literature I',            'ENGL 313', 300, 3, 'African American literary tradition from its beginnings through the Harlem Renaissance. Slave narratives, post-Reconstruction writing, Du Bois, and the major figures of the Renaissance read in cultural and historical context. Three lecture hours. Prerequisite: ENGL 102.'),
    (74, 2, 'African American Literature II',           'ENGL 314', 300, 3, 'Continuation of ENGL 313, from the post-Renaissance period to the present. The Black Arts Movement, womanist and Black feminist writing, contemporary novelists and poets, and African American literary theory. Three lecture hours. Prerequisite: ENGL 102.'),
    (75, 2, 'Shakespeare',                              'ENGL 331', 300, 3, 'Close study of representative comedies, tragedies, histories, and romances in their dramatic and historical context. Students attend at least one live or recorded performance and write critical essays grounded in the texts. Three lecture hours. Prerequisite: ENGL 102.'),
    (76, 2, 'Literature of the African Diaspora',       'ENGL 350', 300, 3, 'Literature written by people of African descent across the Atlantic world. Texts from the Caribbean, Africa, the Americas, and Black Britain in dialogue with one another. Three lecture hours. Prerequisite: ENGL 102.'),
    (77, 2, 'Advanced Composition',                     'ENGL 365', 300, 3, 'Advanced expository and argumentative writing. Extended writing projects with intensive revision, peer workshop, and conference with the instructor. Required of English majors and recommended for any student preparing for graduate or professional study. Three lecture hours. Prerequisite: ENGL 102.'),
    (78, 2, 'Literary Criticism',                       'ENGL 401', 400, 3, 'Major movements in literary criticism and theory from antiquity to the present. Formalism, structuralism, poststructuralism, feminist and gender criticism, postcolonial and critical race theory, with applications to representative literary works. Three lecture hours. Prerequisite: ENGL 102 and one 300-level ENGL course.'),
    (79, 2, 'History of the English Language',          'ENGL 421', 400, 3, 'Development of the English language from Old English through Middle and Early Modern English to contemporary global Englishes. Phonology, morphology, syntax, and lexicon over time, with attention to language contact and standardization. Three lecture hours.'),
    (80, 2, 'Senior Seminar in English',                'ENGL 491', 400, 3, 'Capstone seminar for English majors. Intensive study of a specialized topic chosen by the instructor, culminating in a substantial research paper. Counts toward the senior comprehensive requirement. Three lecture hours. Prerequisite: senior standing in English.');

-- Biology (dept 18, code BIOL)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (81, 18, 'Introduction to Biology I',               'BIOL 101', 100, 4, 'First course in the major biology sequence. Introduction to cell structure and function, biochemistry, cell metabolism, cell division, and the molecular basis of inheritance, with weekly laboratory. Required of biology majors and pre-health students. Counts toward the Biological and Physical Sciences general-education requirement. Three lecture and three lab hours weekly.'),
    (82, 18, 'Introduction to Biology II',              'BIOL 102', 100, 4, 'Second course in the major biology sequence. Evolution, organismal diversity, plant and animal anatomy and physiology, and ecology, with weekly laboratory. Three lecture and three lab hours weekly. Prerequisite: BIOL 101.'),
    (83, 18, 'Introduction to Biology',                 'BIOL 105', 100, 4, 'Single-semester general-education biology for non-science majors. Survey of cellular biology, genetics, evolution, organismal diversity, and ecology, with laboratory. Cannot be substituted for BIOL 101 by biology majors. Counts toward the Biological and Physical Sciences general-education requirement.'),
    (84, 18, 'Foundations of Biology II: Cell Structure and Function', 'BIOL 111', 100, 4, 'Honors first-semester general biology for biology majors in the Honors program. Coverage parallel to BIOL 101 with additional depth and primary-literature reading. Weekly laboratory. Three lecture and three lab hours weekly. Prerequisite: Honors program standing.'),
    (85, 18, 'Honors Introductory Biology II',          'BIOL 112', 100, 4, 'Honors continuation parallel to BIOL 102 for biology majors in the Honors program. Three lecture and three lab hours weekly. Prerequisite: BIOL 111.'),
    (86, 18, 'Human Anatomy and Physiology I',          'BIOL 201', 200, 4, 'First semester of a two-semester sequence covering the structure and function of the human body. Cellular and tissue organization, the integumentary, skeletal, muscular, and nervous systems, with laboratory. Required for nursing and many allied health majors. Three lecture and three lab hours weekly. Prerequisite: BIOL 101 or BIOL 105.'),
    (87, 18, 'Human Anatomy and Physiology II',         'BIOL 202', 200, 4, 'Continuation of BIOL 201. The endocrine, cardiovascular, lymphatic, immune, respiratory, digestive, urinary, and reproductive systems, with laboratory. Three lecture and three lab hours weekly. Prerequisite: BIOL 201.'),
    (88, 18, 'Genetics',                                'BIOL 209', 200, 4, 'Principles of classical and molecular genetics. Mendelian inheritance, linkage and mapping, the molecular structure and function of DNA, gene expression and regulation, mutation, and an introduction to population genetics, with laboratory. Three lecture and three lab hours weekly. Prerequisite: BIOL 102.'),
    (89, 18, 'Cell and Molecular Biology',              'BIOL 310', 300, 4, 'Structure, function, and regulation of eukaryotic cells at the molecular level. Membranes, organelles, the cytoskeleton, signal transduction, the cell cycle, and cellular techniques. Laboratory uses molecular and cell-biology methods on real samples. Three lecture and three lab hours weekly. Prerequisite: BIOL 209 and CHEM 203.'),
    (90, 18, 'General Microbiology',                    'BIOL 308', 300, 4, 'Introduction to microorganisms. Bacterial structure and physiology, microbial genetics, virology, immunology, and host-microbe interactions, with extensive laboratory in microbiological technique. Three lecture and three lab hours weekly. Prerequisite: BIOL 102 and CHEM 105.'),
    (91, 18, 'Ecology',                                 'BIOL 320', 300, 3, 'Principles of ecology at the population, community, and ecosystem levels. Population dynamics, species interactions, community structure, energy flow, and biogeochemical cycles, with attention to anthropogenic disturbance and conservation. Three lecture hours. Prerequisite: BIOL 102.'),
    (92, 18, 'Evolution',                               'BIOL 325', 300, 3, 'Mechanisms and patterns of evolution. Natural selection, genetic drift, speciation, phylogenetics, the fossil record, and human evolution, with critical reading of primary literature. Three lecture hours. Prerequisite: BIOL 209.'),
    (93, 18, 'Comparative Vertebrate Anatomy',          'BIOL 330', 300, 4, 'Comparative anatomy of the vertebrates. Phylogeny and evolution of the vertebrate body plan, organ-system evolution, and laboratory dissection of representative vertebrates. Three lecture and three lab hours weekly. Prerequisite: BIOL 102.'),
    (94, 18, 'General Physiology',                      'BIOL 340', 300, 4, 'Animal physiology with comparative emphasis. Cellular physiology, neural and muscular function, cardiovascular and respiratory physiology, osmoregulation, and endocrinology, with laboratory. Three lecture and three lab hours weekly. Prerequisite: BIOL 102 and CHEM 106.'),
    (95, 18, 'Immunology',                              'BIOL 411', 400, 3, 'Cellular and molecular immunology. Innate and adaptive immunity, antigen recognition, antibody structure and function, T-cell biology, immune regulation, and clinical applications including vaccination and immunodeficiency. Three lecture hours. Prerequisite: BIOL 310.'),
    (96, 18, 'Molecular Biology',                       'BIOL 420', 400, 4, 'Advanced treatment of nucleic acid structure, replication, transcription, translation, and gene regulation in prokaryotes and eukaryotes. Laboratory uses recombinant DNA techniques on real samples. Three lecture and three lab hours weekly. Prerequisite: BIOL 310.'),
    (97, 18, 'Biochemistry',                            'BIOL 430', 400, 3, 'Structure, function, and metabolism of biological macromolecules. Proteins, enzyme kinetics, carbohydrates, lipids, and integrated metabolism, with applications to human health. Cross-listed with CHEM 304. Three lecture hours. Prerequisite: CHEM 204 and BIOL 209.'),
    (98, 18, 'Scientific Communication',                'BIOL 453', 400, 3, 'Reading, writing, and presenting in the biological sciences. Critical analysis of primary scientific literature, scientific writing for different audiences, and oral presentation skills. Required of biology majors as a senior writing course. Three lecture hours. Prerequisite: senior standing.'),
    (99, 18, 'Senior Research',                         'BIOL 491', 400, 3, 'Independent senior research project under the direction of a biology faculty member. Students write a thesis-style report and present results at a department symposium. Three credit hours. Prerequisite: senior standing and faculty approval.'),
    (100, 18, 'Senior Comprehensive Examination',        'BIOL 001', 400, 0, 'Zero-credit registration vehicle for the Biology Senior Departmental Comprehensive Examination, required of all biology majors for graduation. Examination covers content from across the major curriculum. Prerequisite: senior standing.');

-- Chemistry (dept 19, code CHEM)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (101, 19, 'General Chemistry I',                     'CHEM 101', 100, 3, 'General-education general chemistry I for students whose majors do not require the major chemistry sequence. Atomic structure, periodicity, stoichiometry, gas laws, and basic thermochemistry. Three lecture hours; laboratory taken concurrently as CHEM 101L. Counts toward the Biological and Physical Sciences general-education requirement.'),
    (102, 19, 'General Chemistry I Laboratory',          'CHEM 101L', 100, 1, 'Laboratory companion to CHEM 101. Introductory laboratory techniques in measurement, stoichiometry, solution preparation, and basic instrumentation. Three lab hours weekly. Co-requisite: CHEM 101.'),
    (103, 19, 'Principles of General Chemistry I',       'CHEM 105', 100, 3, 'Major-track general chemistry I. Modern atomic theory, chemical bonding, stoichiometry, gas laws, thermochemistry, and an introduction to the periodic properties of the elements. For students in chemistry, biology, engineering, and other majors requiring 200-level chemistry. Three lecture hours; laboratory taken concurrently as CHEM 105L.'),
    (104, 19, 'Principles of General Chemistry I Lab',   'CHEM 105L', 100, 1, 'Laboratory companion to CHEM 105. Quantitative laboratory techniques, density and stoichiometric measurements, calorimetry, and an introduction to spectrophotometric measurement. Three lab hours weekly. Co-requisite: CHEM 105.'),
    (105, 19, 'Principles of General Chemistry II',      'CHEM 106', 100, 3, 'Continuation of CHEM 105. Chemical kinetics, chemical equilibrium, acids and bases, solubility, thermodynamics, and electrochemistry. Three lecture hours; laboratory taken concurrently as CHEM 106L. Prerequisite: CHEM 105 with a grade of C or better.'),
    (106, 19, 'Principles of General Chemistry II Lab',  'CHEM 106L', 100, 1, 'Laboratory companion to CHEM 106. Equilibrium experiments, titrations including acid-base and redox titration, kinetics, and electrochemical cells. Three lab hours weekly. Co-requisite: CHEM 106.'),
    (107, 19, 'General Chemistry for Engineering Students', 'CHEM 110', 100, 3, 'Single-semester general chemistry designed for engineering students. Coverage parallel to CHEM 105 with additional emphasis on materials and properties relevant to engineering practice. Three lecture hours; laboratory taken concurrently as CHEM 110L. Prerequisite: MATH 113 or placement.'),
    (108, 19, 'General Chemistry for Engineers Lab',     'CHEM 110L', 100, 1, 'Laboratory companion to CHEM 110. Engineering-relevant laboratory experiments emphasizing measurement, accuracy, and laboratory safety. Three lab hours weekly. Co-requisite: CHEM 110.'),
    (109, 19, 'General Chemistry -- Honors',             'CHEM 111', 100, 3, 'Honors version of CHEM 105 for chemistry majors and Honors-program students. Coverage parallel to CHEM 105 with additional rigor and primary-literature components. Three lecture hours; laboratory taken concurrently as CHEM 111L. Prerequisite: Honors program or instructor permission.'),
    (110, 19, 'General Chemistry Honors Lab',            'CHEM 111L', 100, 1, 'Laboratory companion to CHEM 111. Honors-level laboratory work emphasizing experimental design and quantitative analysis. Three lab hours weekly. Co-requisite: CHEM 111.'),
    (111, 19, 'Organic Chemistry for Health Sciences',   'CHEM 201', 200, 4, 'Single-semester survey of organic chemistry for nursing, allied health, and other health-science majors. Major functional groups and their reactions with emphasis on biological and pharmaceutical relevance. Three lecture and three lab hours weekly. Prerequisite: CHEM 105 / 105L or CHEM 101 / 101L.'),
    (112, 19, 'Biochemistry for Health Sciences Majors', 'CHEM 202', 200, 3, 'Single-semester biochemistry survey for health-science majors. Structure and function of biological macromolecules, enzyme action, and integrated metabolism with emphasis on human health. Three lecture hours. Prerequisite: CHEM 201.'),
    (113, 19, 'Organic Chemistry I',                     'CHEM 203', 200, 3, 'First course in the major organic chemistry sequence. Structure, bonding, nomenclature, and reactions of alkanes, alkenes, alkynes, and alkyl halides, with emphasis on reaction mechanisms. Three lecture hours; laboratory taken concurrently as CHEM 203L. Prerequisite: CHEM 106 / 106L with a grade of C or better.'),
    (114, 19, 'Organic Chemistry I Laboratory',          'CHEM 203L', 200, 1, 'Laboratory companion to CHEM 203. Recrystallization, distillation, extraction, chromatography, and synthesis of representative organic compounds. Three lab hours weekly. Co-requisite: CHEM 203.'),
    (115, 19, 'Organic Chemistry II',                    'CHEM 204', 200, 3, 'Continuation of CHEM 203. Aromatic compounds, alcohols, ethers, aldehydes, ketones, carboxylic acids and derivatives, amines, and an introduction to spectroscopy (IR and NMR). Three lecture hours; laboratory taken concurrently as CHEM 204L. Prerequisite: CHEM 203 / 203L.'),
    (116, 19, 'Organic Chemistry II Laboratory',         'CHEM 204L', 200, 1, 'Laboratory companion to CHEM 204. Multi-step synthesis, instrumental characterization (IR, NMR, mass spectrometry), and identification of unknowns. Three lab hours weekly. Co-requisite: CHEM 204.'),
    (117, 19, 'Quantitative Analysis I',                 'CHEM 207', 200, 4, 'Theory and practice of quantitative chemical analysis. Statistical treatment of data, gravimetric analysis, volumetric analysis (acid-base, redox, complexometric), and an introduction to spectroscopic and electrochemical methods, with extensive laboratory. Three lecture and three lab hours weekly. Prerequisite: CHEM 106 / 106L.'),
    (118, 19, 'Effective Technical Presentations',       'CHEM 300', 300, 1, 'Reading, writing, and oral presentation in chemistry. Critical analysis of primary chemical literature, scientific writing conventions, and presentation of original or assigned chemistry topics. One credit hour. Prerequisite: CHEM 204.'),
    (119, 19, 'Biochemistry I',                          'CHEM 304', 300, 3, 'First course in major biochemistry sequence. Structure and function of proteins, enzyme kinetics and mechanism, carbohydrates, lipids, and an introduction to membrane biochemistry. Three lecture hours. Prerequisite: CHEM 204.'),
    (120, 19, 'Biochemistry II',                         'CHEM 305', 300, 3, 'Continuation of CHEM 304. Bioenergetics, integrated carbohydrate, lipid, and amino-acid metabolism, and the biochemistry of nucleic acids. Three lecture hours. Prerequisite: CHEM 304.'),
    (121, 19, 'Physical Chemistry I',                    'CHEM 307', 300, 3, 'First semester of physical chemistry. Thermodynamics of pure substances and mixtures, chemical equilibrium, phase equilibria, and an introduction to chemical kinetics. Three lecture hours. Prerequisite: CHEM 106, MATH 242, PHYS 206.'),
    (122, 19, 'Physical Chemistry II',                   'CHEM 308', 300, 3, 'Continuation of CHEM 307. Quantum chemistry, atomic and molecular structure, spectroscopy, and statistical thermodynamics. Three lecture hours; laboratory taken concurrently as CHEM 308L. Prerequisite: CHEM 307.'),
    (123, 19, 'Physical Chemistry II Laboratory',        'CHEM 308L', 300, 1, 'Laboratory companion to CHEM 308. Experiments in spectroscopy, kinetics, and quantum-mechanical measurements. Three lab hours weekly. Co-requisite: CHEM 308.'),
    (124, 19, 'Inorganic Chemistry',                     'CHEM 310', 300, 3, 'Modern inorganic chemistry. Atomic structure, ionic and covalent bonding, symmetry and group theory, coordination chemistry, organometallic chemistry, and bioinorganic chemistry. Three lecture hours. Prerequisite: CHEM 204, CHEM 307 recommended.'),
    (125, 19, 'Senior Research',                         'CHEM 491', 400, 3, 'Independent senior research project under the direction of a chemistry faculty member, culminating in a written thesis and oral defense at a department symposium. Required for ACS-certified BS in Chemistry. Three credit hours. Prerequisite: senior standing and faculty approval.');

-- Physics (dept 22, code PHYS)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (126, 22, 'Introduction to Physics',                 'PHYS 101', 100, 4, 'General-education survey of physics for non-science majors. Mechanics, waves, heat, electricity and magnetism, and modern physics, presented at a conceptual level with selected algebra-based problem solving. Three lecture and two lab hours weekly. Counts toward the Biological and Physical Sciences general-education requirement.'),
    (127, 22, 'Introduction to Physics -- Honors',       'PHYS 111', 100, 4, 'Honors version of PHYS 101 for Honors-program students. Coverage parallel to PHYS 101 with additional rigor and project work. Three lecture and two lab hours weekly. Prerequisite: Honors program standing.'),
    (128, 22, 'Algebra-Based Physics I',                 'PHYS 203', 200, 4, 'First semester of algebra/trigonometry-based introductory physics for biology, chemistry, and pre-medical students. Mechanics, fluids, waves, and thermodynamics, with laboratory. Three lecture and three lab hours weekly. Prerequisite: MATH 113.'),
    (129, 22, 'Algebra-Based Physics II',                'PHYS 204', 200, 4, 'Continuation of PHYS 203. Electricity and magnetism, electromagnetic waves, optics, and modern physics, with laboratory. Three lecture and three lab hours weekly. Prerequisite: PHYS 203.'),
    (130, 22, 'General Physics I',                       'PHYS 205', 200, 4, 'Calculus-based introductory physics I for science and engineering majors. Mechanics, oscillations, waves, and thermodynamics, with laboratory. Three lecture and three lab hours weekly. Prerequisite or co-requisite: MATH 241.'),
    (131, 22, 'General Physics II',                      'PHYS 206', 200, 4, 'Continuation of PHYS 205. Electricity and magnetism, electromagnetic waves, optics, and an introduction to modern physics, with laboratory. Three lecture and three lab hours weekly. Prerequisite: PHYS 205. Co-requisite: MATH 242.'),
    (132, 22, 'Modern Physics',                          'PHYS 301', 300, 3, 'Introduction to modern physics. Special relativity, the experimental foundations of quantum mechanics, atomic structure, and an introduction to nuclear and particle physics. Three lecture hours. Prerequisite: PHYS 206 and MATH 242.'),
    (133, 22, 'Classical Mechanics',                     'PHYS 302', 300, 3, 'Intermediate classical mechanics. Newtonian dynamics in vector form, oscillations, central-force motion, rigid-body dynamics, and Lagrangian and Hamiltonian formulations. Three lecture hours. Prerequisite: PHYS 206 and MATH 340.'),
    (134, 22, 'Electricity and Magnetism',               'PHYS 311', 300, 3, 'Intermediate electromagnetism. Electrostatics, magnetostatics, Maxwell equations, electromagnetic waves, and an introduction to radiation. Three lecture hours. Prerequisite: PHYS 206 and MATH 243.'),
    (135, 22, 'Thermodynamics and Statistical Mechanics','PHYS 320', 300, 3, 'Classical thermodynamics and an introduction to statistical mechanics. The laws of thermodynamics, free energies, phase equilibria, the Boltzmann distribution, and quantum statistics. Three lecture hours. Prerequisite: PHYS 206 and MATH 243.'),
    (136, 22, 'Quantum Mechanics I',                     'PHYS 401', 400, 3, 'Introduction to non-relativistic quantum mechanics. The Schrodinger equation, one-dimensional problems, the harmonic oscillator, angular momentum, the hydrogen atom, and an introduction to perturbation theory. Three lecture hours. Prerequisite: PHYS 301 and MATH 312.'),
    (137, 22, 'Optics and Photonics',                    'PHYS 410', 400, 3, 'Geometric and physical optics with applications. Reflection and refraction, lenses and imaging, interference, diffraction, polarization, and an introduction to lasers and photonic devices. Three lecture hours. Prerequisite: PHYS 311.'),
    (138, 22, 'Senior Project in Physics',               'PHYS 491', 400, 3, 'Capstone senior research or design project for physics and engineering physics majors. Independent investigation under faculty supervision, culminating in a written thesis and oral presentation. Required for graduation. Three credit hours. Prerequisite: senior standing.');

-- Information Science and Systems (dept 15, code INSS)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (139, 15, 'Digital Literacy and Application Software', 'INSS 141', 100, 3, 'Introduction to computers and information processing in business. Hands-on experience with commercial productivity software for word processing, spreadsheets, presentations, and databases. Required of all students in the School of Business and Management. Departmental proficiency examination available. Three lecture hours. Offered Fall, Spring, and Summer.'),
    (140, 15, 'Information Systems Foundations',         'INSS 250', 200, 3, 'Foundations of information systems in organizations. Hardware, software, networks, data, and people as components of an enterprise information system. Systems thinking, systems analysis fundamentals, and current trends in business IT. Three lecture hours. Prerequisite: INSS 141 with a grade of C or better.'),
    (141, 15, 'Database Concepts and Applications',      'INSS 260', 200, 3, 'Introduction to database systems for business. Data modeling, the relational model, SQL, normalization, and database application design. Hands-on work with a current relational DBMS. Three lecture hours. Prerequisite: INSS 141 with a grade of C or better.'),
    (142, 15, 'Programming for Information Systems',     'INSS 350', 300, 3, 'Programming for information-systems applications. Structured and object-oriented programming concepts, with hands-on development of small business applications using a current general-purpose language. Three lecture hours. Prerequisite: INSS 250.'),
    (143, 15, 'Systems Analysis and Design',             'INSS 370', 300, 3, 'Methodologies for analyzing business needs and designing information systems to meet them. Requirements elicitation, structured and object-oriented analysis and design, prototyping, and project documentation. Three lecture hours. Prerequisite: INSS 250.'),
    (144, 15, 'Networking and Telecommunications',       'INSS 380', 300, 3, 'Business data communications and networking. The OSI and TCP/IP models, LAN and WAN technologies, network design, network management, and an introduction to network security. Three lecture hours. Prerequisite: INSS 250.'),
    (145, 15, 'Web Application Development',             'INSS 391', 300, 3, 'Server-side and client-side development of business web applications. HTML, CSS, JavaScript, a current server-side framework, database integration, and deployment. Three lecture hours. Prerequisite: INSS 260 and INSS 350.'),
    (146, 15, 'Data Analytics for Enterprises',          'INSS 395', 300, 3, 'Data management and knowledge discovery in business contexts. Master data management and storage architectures; analytic techniques including clustering, decision-tree induction, regression, neural networks, support-vector machines, and text mining. Hands-on assignments using analytics software. Three lecture hours. Prerequisite: INSS 260 with a grade of C or better.'),
    (147, 15, 'Cloud Computing: Concepts and Applications', 'INSS 396', 300, 3, 'Cloud computing from applications and administration to programming and infrastructure development. Single- and multi-data-center management; building and deploying resilient, elastic, cost-efficient cloud applications. Hands-on work in a major public cloud. Three lecture hours. Co-requisite: INSS 391, EEGR 243, or COSC 349.'),
    (148, 15, 'Information Security and Risk Management','INSS 494', 400, 3, 'Information security and risk management for business. Threats and vulnerabilities, security controls, risk-assessment frameworks, security policy and governance, and business continuity. Three lecture hours. Prerequisite: INSS 250 with a grade of C or better.'),
    (149, 15, 'IS Project Development and Management',   'INSS 490', 400, 3, 'Information-systems capstone. Project-management knowledge areas applied to a substantial team-based information systems project: students analyze, design, implement, and test at least one module of an IT project drawing on the entire INSS curriculum. Three lecture hours. Prerequisite: INSS 260, INSS 370, INSS 380.'),
    (150, 15, 'Current Issues in Information Systems',   'INSS 491', 400, 3, 'Special-topics course on timely subjects in information systems not covered in the regular curriculum. Topic and additional prerequisites are announced in advance by the instructor. Three lecture hours. Prerequisite: INSS 250 with a grade of C or better.'),
    (151, 15, 'Special Topics in Information Systems',   'INSS 492', 400, 3, 'Special-topics seminar addressing specific trends in information systems. Three lecture hours. Prerequisite: INSS 250 and INSS 360 with a grade of C or better.');

-- Electrical and Computer Engineering (dept 27, code EEGR)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (152, 27, 'Introduction to Electrical Engineering', 'EEGR 101', 100, 1, 'Orientation course for first-year electrical engineering students. Overview of the EE discipline and sub-fields, the engineering design process, professional ethics, and the academic and professional expectations of the program. One lecture hour. Required of all electrical engineering majors.'),
    (153, 27, 'Computational Methods for Engineering', 'EEGR 109', 100, 3, 'Introduction to computational problem solving for engineering students. Algorithm design, programming in a current scientific computing environment, basic numerical methods, and engineering data analysis. Three lecture hours. Prerequisite: MATH 113.'),
    (154, 27, 'Circuit Analysis I',                     'EEGR 202', 200, 3, 'DC and AC circuit analysis. Kirchhoff laws, node and mesh analysis, network theorems, operational-amplifier circuits, transient analysis of first- and second-order circuits, and steady-state sinusoidal analysis. Three lecture hours. Prerequisite: PHYS 206 and MATH 242.'),
    (155, 27, 'Circuit Analysis II',                    'EEGR 203', 200, 3, 'Continuation of EEGR 202. Sinusoidal steady-state power, three-phase circuits, magnetically coupled circuits, frequency response, two-port networks, and an introduction to Laplace-transform analysis. Three lecture hours. Prerequisite: EEGR 202.'),
    (156, 27, 'Electrical Engineering Laboratory I',    'EEGR 240', 200, 1, 'Companion laboratory to EEGR 202. Laboratory measurement of DC and AC circuits, oscilloscope and multimeter techniques, and report writing. Three lab hours weekly. Co-requisite: EEGR 202.'),
    (157, 27, 'Programming for Engineers',              'EEGR 243', 200, 3, 'Object-oriented programming for engineers. Programming fundamentals, data structures, and software-engineering practice in a current general-purpose language, with engineering-oriented programming projects. Three lecture hours. Prerequisite: EEGR 109.'),
    (158, 27, 'Digital Logic Circuits',                 'EEGR 281', 200, 3, 'Digital logic design. Boolean algebra, combinational and sequential logic, design of arithmetic and storage circuits, an introduction to hardware description languages, and design of small digital systems. Three lecture hours. Prerequisite: EEGR 202.'),
    (159, 27, 'Signals and Systems',                    'EEGR 309', 300, 3, 'Continuous- and discrete-time signals and systems. Linearity and time-invariance, convolution, Fourier series and transforms, the Laplace and z-transforms, and an introduction to filtering. Three lecture hours. Prerequisite: EEGR 203 and MATH 340.'),
    (160, 27, 'Electronics I',                          'EEGR 311', 300, 3, 'Electronic devices and circuits. Diodes, BJT and MOSFET transistor characteristics, biasing and small-signal analysis, single-stage amplifiers, and an introduction to multistage amplifier design. Three lecture hours. Prerequisite: EEGR 203.'),
    (161, 27, 'Electromagnetics',                       'EEGR 315', 300, 3, 'Engineering electromagnetics. Electrostatics, magnetostatics, Maxwell equations in differential and integral form, plane-wave propagation, transmission lines, and an introduction to waveguides and antennas. Three lecture hours. Prerequisite: PHYS 206 and MATH 243.'),
    (162, 27, 'Microprocessor Systems',                 'EEGR 383', 300, 3, 'Microprocessor architecture and assembly programming. Instruction sets, memory organization, interrupts, I/O, and the design of small embedded systems built around a current microcontroller. Three lecture and three lab hours weekly. Prerequisite: EEGR 281.'),
    (163, 27, 'Communications Systems',                 'EEGR 411', 400, 3, 'Analog and digital communications. Modulation techniques (AM, FM, PM, PCM, ASK, FSK, PSK), noise in communication systems, and an introduction to digital data transmission and information theory. Three lecture hours. Prerequisite: EEGR 309.'),
    (164, 27, 'Control Systems',                        'EEGR 421', 400, 3, 'Linear feedback control systems. Modeling of physical systems, transfer functions, time- and frequency-domain analysis, stability criteria, root-locus and Bode-plot design methods, and an introduction to state-space methods. Three lecture hours. Prerequisite: EEGR 309.'),
    (165, 27, 'Digital Signal Processing',              'EEGR 481', 400, 3, 'Discrete-time signal processing. Sampling, the discrete and fast Fourier transforms, digital filter design (FIR and IIR), and applications to audio, image, and communications. Three lecture hours. Prerequisite: EEGR 309.'),
    (166, 27, 'Embedded Systems Design',                'EEGR 483', 400, 3, 'Design of embedded computing systems. Real-time programming, microcontrollers and peripherals, sensor and actuator interfacing, communication protocols (I2C, SPI, UART, CAN), and project-based design of a working embedded system. Three lecture and three lab hours weekly. Prerequisite: EEGR 383.'),
    (167, 27, 'Senior Design Project',                  'EEGR 491', 400, 3, 'Capstone two-semester senior design experience. Teams identify a real-world engineering problem, generate and evaluate design alternatives, and develop a working prototype, with formal reviews. Required for graduation. Three credit hours. Prerequisite: senior standing.');

-- Civil Engineering (dept 26, code CEGR)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (168, 26, 'Introduction to Civil Engineering',      'CEGR 106', 100, 1, 'Orientation course introducing students to the concept of engineering design through exposure to several design problems from various areas of civil engineering, including structural, transportation, geotechnical, and environmental engineering. Required of all civil engineering majors. Two lecture hours. Offered Fall and Spring.'),
    (169, 26, 'Computer-Aided Engineering Graphics, Analysis, and Design', 'CEGR 107', 100, 3, 'Introduction to computer-aided engineering graphics and engineering analysis through visualization, definition, and solution of simple civil engineering design problems. Review of geometry and trigonometry alongside CAD software. Two lecture and two studio hours weekly. Co-requisite: MATH 113.'),
    (170, 26, 'Statics',                                'CEGR 202', 200, 3, 'Force systems, equilibrium of particles and rigid bodies, analysis of structures (trusses, frames, machines), distributed forces, centroids, moments of inertia, and friction. Three lecture hours. Prerequisite: PHYS 205 and MATH 242.'),
    (171, 26, 'Mechanics of Materials',                 'CEGR 212', 200, 3, 'Stress and strain, axial loads, torsion, bending of beams, shear and bending-moment diagrams, deflection of beams, combined loadings, and an introduction to column buckling. Three lecture hours. Prerequisite: CEGR 202.'),
    (172, 26, 'Surveying',                              'CEGR 214', 200, 3, 'Plane surveying for civil engineers. Distance, angle, and elevation measurement; differential leveling; traverse computations; topographic mapping; and an introduction to GPS and GIS, with field practice. Two lecture and three field hours weekly. Prerequisite: MATH 113.'),
    (173, 26, 'Dynamics',                               'CEGR 302', 300, 3, 'Kinematics and kinetics of particles and rigid bodies in one- and two-dimensional motion. Friction, mass moments of inertia, motion of particle systems, impulse-momentum and work-energy methods, simple 3D gyroscopic motion, and free and forced vibrations. Includes computer-simulation problems. Three lecture hours. Prerequisite: CEGR 202 and CEGR 212.'),
    (174, 26, 'Engineering Mechanics',                  'CEGR 304', 300, 4, 'Combined statics and introductory dynamics for non-civil engineering majors. Closed to civil engineering majors. Resolution, composition, and equilibrium of forces; force-system analysis; centers of gravity; moments of inertia; motion study; Newton laws; work-energy, impulse-momentum, and power. Four lecture hours weekly. Prerequisite: MATH 242 and PHYS 205.'),
    (175, 26, 'Computer Methods and Programming for Civil Engineering', 'CEGR 307', 300, 2, 'Computer methods and programming for civil-engineering analysis and design. Linear algebra basics, numerical-analysis algorithms, algorithm development, types and classes, and the conversion of mathematical equations to software. Spreadsheet and computational-math software for routine analysis and design. One lecture and three practicum hours weekly. Prerequisite: CEGR 107.'),
    (176, 26, 'Structural Analysis',                    'CEGR 312', 300, 3, 'Analysis of statically determinate and indeterminate structures. Influence lines, deflections by virtual work and direct integration, the slope-deflection method, the moment-distribution method, and an introduction to matrix methods. Three lecture hours. Prerequisite: CEGR 212.'),
    (177, 26, 'Geotechnical Engineering and Laboratory','CEGR 325', 300, 3, 'Basic physical and mechanical characteristics of soils. Soil classification, permeability and seepage, in-situ stresses and compressibility, lateral earth pressures, slope stability, and bearing capacity of shallow foundations, with laboratory. Two lecture and three lab hours weekly. Prerequisite: CEGR 202 and CEGR 212.'),
    (178, 26, 'Hydraulic Engineering',                  'CEGR 332', 300, 3, 'Hydraulics for civil engineers. Hydrology, open-channel flow, pipe flow, ground-water flow, dams, and reservoirs. Computer programming assignments are incorporated. Three lecture hours. Prerequisite: BIOL 101, CEGR 214, and MATH 242.'),
    (179, 26, 'Environmental Engineering',              'CEGR 340', 300, 3, 'Introduction to environmental engineering. Water quality and water treatment, wastewater collection and treatment, air-quality engineering, and solid- and hazardous-waste management. Three lecture hours. Prerequisite: CEGR 332 or instructor permission.'),
    (180, 26, 'Transportation Engineering',             'CEGR 350', 300, 3, 'Introduction to transportation engineering. Highway geometric design, traffic flow theory, capacity analysis, transportation planning, and an introduction to public-transit and freight systems. Three lecture hours. Prerequisite: CEGR 214.'),
    (181, 26, 'Reinforced Concrete Design',             'CEGR 412', 400, 3, 'Design of reinforced-concrete structural elements per current ACI code. Behavior, analysis, and design of beams, slabs, columns, and footings, with project-based design assignments. Three lecture hours. Prerequisite: CEGR 312.'),
    (182, 26, 'Steel Design',                           'CEGR 413', 400, 3, 'Design of structural-steel members and connections per current AISC code. Tension and compression members, beams, beam-columns, and bolted and welded connections. Three lecture hours. Prerequisite: CEGR 312.'),
    (183, 26, 'Senior Design Project',                  'CEGR 491', 400, 3, 'Capstone civil engineering design course. Multidisciplinary team project addressing a realistic civil-engineering problem, with full design, cost, and constructability deliverables, and formal client and faculty reviews. Required for graduation. Three credit hours. Prerequisite: senior standing.');

-- Psychology (dept 7, code PSYC)
INSERT INTO courses (id, department_id, title, code, level, credits, description) VALUES
    (184, 7, 'Introductory Psychology',                 'PSYC 101', 100, 3, 'Survey of major topics, theories, and research methods in psychology. Biological bases of behavior, sensation and perception, learning and memory, cognition, development, personality, social psychology, psychopathology, and treatment. Required of psychology majors and counts toward general-education requirements for non-majors. Three lecture hours.'),
    (185, 7, 'Developmental Psychology',                'PSYC 211', 200, 3, 'Human development across the lifespan. Physical, cognitive, social, and emotional development from infancy through late adulthood, with attention to cultural variation and the role of context. Three lecture hours. Prerequisite: PSYC 101.'),
    (186, 7, 'Statistics for Behavioral Sciences',      'PSYC 220', 200, 3, 'Descriptive and inferential statistics for psychological and behavioral research. Measures of central tendency and variability, correlation and regression, the normal distribution, hypothesis testing, t tests, analysis of variance, and chi-square. Hands-on use of statistical software. Three lecture hours. Prerequisite: PSYC 101 and MATH 113.'),
    (187, 7, 'Research Methods in Psychology',          'PSYC 230', 200, 3, 'Principles of psychological research. Research designs (experimental, quasi-experimental, correlational, observational), measurement and reliability, ethical conduct of research with human subjects, and APA-style scientific writing. Three lecture hours. Prerequisite: PSYC 101 and PSYC 220.'),
    (188, 7, 'Abnormal Psychology',                     'PSYC 305', 300, 3, 'Description, etiology, and treatment of psychological disorders. Current diagnostic systems (DSM-5), the major categories of mental disorder, and contemporary biological, psychological, and sociocultural approaches to treatment. Three lecture hours. Prerequisite: PSYC 101.'),
    (189, 7, 'Social Psychology',                       'PSYC 311', 300, 3, 'Scientific study of how people think about, influence, and relate to one another. Social cognition, attitudes, persuasion, conformity, group processes, prejudice and intergroup relations, aggression, prosocial behavior, and close relationships. Three lecture hours. Prerequisite: PSYC 101.'),
    (190, 7, 'Cognitive Psychology',                    'PSYC 320', 300, 3, 'Scientific study of human cognition. Attention, perception, memory, language, problem solving, decision making, and reasoning, with discussion of representative neuroscientific evidence. Three lecture hours. Prerequisite: PSYC 101.'),
    (191, 7, 'Biological Psychology',                   'PSYC 330', 300, 3, 'Biological bases of behavior. Neuroanatomy and neurophysiology, sensory and motor systems, sleep and arousal, learning and memory, motivation and emotion, and the biology of psychological disorders. Three lecture hours. Prerequisite: PSYC 101 and BIOL 101 or BIOL 105.'),
    (192, 7, 'Personality',                             'PSYC 340', 300, 3, 'Major theories of personality and their empirical bases. Psychodynamic, humanistic, trait, social-cognitive, and biological approaches, with discussion of personality assessment and contemporary research. Three lecture hours. Prerequisite: PSYC 101.'),
    (193, 7, 'Psychology of the African American Experience', 'PSYC 350', 300, 3, 'Psychological theory and research on the African American experience. Identity development, racism and its psychological effects, family and community, achievement and education, and culturally informed approaches to assessment and intervention. Three lecture hours. Prerequisite: PSYC 101.'),
    (194, 7, 'Tests and Measurement',                   'PSYC 360', 300, 3, 'Principles of psychological testing and measurement. Reliability, validity, item analysis, and standardization; major categories of tests including intelligence, personality, achievement, and clinical instruments; and ethical and legal issues in test use. Three lecture hours. Prerequisite: PSYC 220.'),
    (195, 7, 'Industrial-Organizational Psychology',    'PSYC 370', 300, 3, 'Psychology applied to the workplace. Personnel selection and assessment, training, performance management, motivation, leadership, and organizational behavior. Three lecture hours. Prerequisite: PSYC 101.'),
    (196, 7, 'Counseling Psychology',                   'PSYC 410', 400, 3, 'Theories and practice of counseling psychology. Major theoretical orientations (psychodynamic, humanistic, cognitive-behavioral, family systems, multicultural), the counseling relationship, ethics, and the practice of counseling in diverse settings. Three lecture hours. Prerequisite: PSYC 305.'),
    (197, 7, 'Health Psychology',                       'PSYC 420', 400, 3, 'Psychological factors in health, illness, and healthcare. Stress and coping, health behavior change, chronic illness, pain, and the social determinants of health, with attention to health disparities affecting urban and African American populations. Three lecture hours. Prerequisite: PSYC 101.'),
    (198, 7, 'Senior Seminar in Psychology',            'PSYC 491', 400, 3, 'Capstone seminar for psychology majors. Intensive study of a specialized topic chosen by the instructor, culminating in a substantial empirical or library research paper. Counts toward the senior comprehensive requirement. Three lecture hours. Prerequisite: senior standing in psychology, PSYC 230.');
    
-- ---------------------------------------------------------------------------
-- PREREQUISITES
-- grouping is used for "either-or" prereq logic: same grouping = OR,
-- different groupings = AND.
-- ---------------------------------------------------------------------------
INSERT INTO prerequisites (grouping, course_id, requires_id, min_grade) VALUES
    (1, 2,  1,  2),  -- COSC 112 requires COSC 111
    (1, 3,  2,  2),  -- COSC 220 requires COSC 112
    (1, 4,  2,  2),  -- COSC 281 requires COSC 112 (AND)
    (2, 4,  5,  2),  -- COSC 281 also requires COSC 241 (AND)
    (1, 6,  4,  2),  -- COSC 351 requires COSC 281
    (1, 7,  4,  2),  -- COSC 458 requires COSC 281
    (1, 8,  3,  2),  -- COSC 354 requires COSC 220
    (1, 10, 7,  2),  -- COSC 491 requires COSC 458
    (1, 14, 13, 2),  -- MATH 242 requires MATH 241
    (1, 15, 14, 2),  -- MATH 312 requires MATH 242
    (1, 18, 17, 2),  -- ENGL 102 requires ENGL 101
    (1, 22, 21, 2),  -- BIOL 102 requires BIOL 101
    (1, 26, 25, 2),  -- CHEM 106 requires CHEM 105
    (1, 27, 26, 2),  -- CHEM 301 requires CHEM 106
    (1, 29, 28, 2),  -- PHYS 206 requires PHYS 205
    (1, 35, 34, 2),  -- EEGR 281 requires EEGR 202
    (1, 41, 40, 2);  -- ECON 212 requires ECON 211

-- ---------------------------------------------------------------------------
-- FACULTY
-- Real department/college mappings; chair, dean, and advisor roles.
-- ---------------------------------------------------------------------------
INSERT INTO faculty (id, email, prefix, first_name, last_name, college_id, department_id, role, bio) VALUES
    -- Computer Science
    (1, 'shuangbao.wang@morgan.edu',     'Dr.', 'Shuangbao',  'Wang',         5, 20, 'chair', 'Paul Wang is a Professor and the Chairperson of Computer Science at Morgan State University. He also holds a faculty position at University of Maryland, College Park. Paul is a Fellow of National Quantum Lab, a LINK Fellow,  and has held positions as the TSYS Endowed Chair in Cybersecurity by a $5 million endorsement, Director of Center for Security Studies with more than 3,000 cyber students, and Chief Information and Technology Officer (CIO/CTO) of the National Biomedical Research Foundation. He has been a consultant to many companies and serving on multiple boards and government and private sector technology committees. Paul was directly involved in drafting of the National Initiatives of Cybersecurity Education (NICE) framework. His research areas are quantum crypto, secure architecture, AI/ML, IoT/CPS, and video indexing.'),
    (2, 'md.rahman@morgan.edu',          'Dr.', 'Md',         'Rahman',       5, 20, 'administrator', 'Computer Vision, Image Processing, Information Retrieval, Machine Learning, and Data Mining and their application to retrieval for relevant and actionable information to achieving clinical and research goals in biomedicine. Dr. Rahman''s research objectives may be formulated as seeking better ways to retrieve information from Biomedical images by moving beyond conventional text-based searching to combining both text and visual features in search queries. The approaches to meeting these objectives use a combination of techniques and tools from the above-mentioned fields.'),  -- Associate Chair, Director of PhD Advanced Computing
    (3, 'radwan.shushane@morgan.edu',    'Dr.', 'Radhouane',  'Chouchane',    5, 20, 'advisor', 'My current research and development interests concern the application of explainable artificial intelligence and machine learning to the task of detecting a given, possibly malicious, cyber activity.'),        -- Director of Undergraduate Studies
    -- Professors / Associate Professors / Assistant Professors
    (4, 'amjad.ali@morgan.edu',          'Dr.', 'Amjad',      'Ali',          5, 20, 'professor', 'Research Interests: Cybersecurity, Artificial Intelligence, Critical Infrastructure Security, Security Policy and Privacy, Bring Your Own Device (BYOD) security, Smart Cities & Security, Mobile Security and Cloud Security.'),
    (5, 'monireh.dabaghchian@morgan.edu','Dr.', 'Monireh',    'Dabaghchian',  5, 20, 'professor', 'Dr. Dabaghchian’s research lies at the intersection of cybersecurity and machine learning (ML). She is interested in studying and analyzing the threats, vulnerabilities, and risks present in IoT devices such as civilian Unmanned Aerial Vehicles (UAV), smart cars, and intelligent vehicle platooning in autonomous vehicles. She is also interested in security of cyber-physical systems as well as spectrum sharing wireless networks. She applies existing machine learning techniques and designs new ML algorithms with theoretical analysis to design effective and robust defense mechanisms to mitigate potential cybersecurity threats.'),
    (6, 'jamell.dacon@morgan.edu',       'Dr.', 'Jamell',     'Dacon',        5, 20, 'professor', 'Artificial Intelligence, Machine Learning, Computational Social Science and Natural Language Processing, especially in areas of Fairness & Bias in AI/ML/NLP, Human-Computer Interaction, Data Science for Social Good, and AI + X: Education and Healthcare with applications for people with disabilities (PWDs), criminal justice, and more. Specifically, focused on empirically modeling social factors such as Race, Gender & Language, and conceptualizing and mitigating socioethical implications (e.g., bias, stereotypes, and representational harms) in new and innovative technology. Selected Publications'),
    (7, 'jin.guo@morgan.edu',            'Dr.', 'Jin',        'Guo',          5, 20, 'professor', ''),
    (8, 'vahid.heydari@morgan.edu',      'Dr.', 'Vahid',      'Heydari',      5, 20, 'professor', 'Dr. Heydari''s research interests lie within Moving Target Defense (MTD) methods, Zero Trust networking, security and privacy of Industrial Control Systems and the Internet of Things, Wireless Networks, Wearable Medical Devices, and applications of Machine Learning in Malware Analysis. He has worked on detecting different attacks against Mobile Ad Hoc Networks (MANETs) and the reliability of data collection in Wireless Sensor Networks (WSNs). He also proposed a queuing analysis for delay calculation in Wireless Ad Hoc Networks.'),
    (9, 'naja.mack@morgan.edu',          'Dr.', 'Naja',       'Mack',         5, 20, 'professor', 'My main research interest is to study the ways Artificial Intelligence will and has impacted humans and how we can design, build, and evaluate multimodal, interactive, intelligent systems that are usable, acceptable, and beneficial to humans, as well as respect human values.'),
    (10, 'jianzhou.mao@morgan.edu',       'Dr.', 'Jianzhou',   'Mao',          5, 20, 'professor', ''),
    (11, 'blessing.ojeme@morgan.edu',     'Dr.', 'Blessing',   'Ojeme',        5, 20, 'professor', 'Artificial intelligence (AI), machine learning (theory and algorithms), deep learning, image processing, computer vision, bioinformatics, human computer interactions (HCI), and information storage and retrieval. My main interest is in investigating better ways of solving real-world problems using computing technologies.'),
    (12, 'roshan.paudel@morgan.edu',      'Dr.', 'Roshan',     'Paudel',       5, 20, 'professor', 'High performance computing, Bioinformatics, Next-Generation Sequencing Analysis, Computational Biology, CS Education, Computational Modeling and Simulation. The main research interest involves developing stochastic models of Calcium and other ion channels in cardiac myocytes. I am also involved in educational research in increasing undergraduate retention rate in computer science as well as integration of critical thinking, active learning and project based learning into intro to CS programming courses.'),      -- also coordinates MS in Bioinformatics
    (13, 'eric.sakk@morgan.edu',          'Dr.', 'Eric',       'Sakk',         5, 20, 'professor', 'Research Interests: Dynamical systems, machine learning, system theory, computer systems, communications systems and bioinformatics.'),
    (14, 'vojislav.stojkovic@morgan.edu', 'Dr.', 'Vojislav',   'Stojkovic',    5, 20, 'professor', 'Bioinformatics (BioAlgorithms, BioProgramming); Cyber Security and Information Assurance; Artificial Intelligence (Agents, Multiagent Systems); Formal Languages (Grammars, Automata/Machines); Programming Languages; Compiler/Interpreter Design; Parallel, Distributed, High Performance, Quantum, DNA Computing; Data Science (Data Science Techniques and Algorithms); Machine Learning (Deep Learning and other approaches).'),
    (15, 'timothy.oladunni@morgan.edu',   'Dr.', 'Timothy',    'Oladunni',     5, 20, 'professor', 'I explore computer science fundamental concepts in developing sustainable, efficient, and innovative solutions to real-world problems. Combining theoretical analysis, and computational paradigms, with deductive reasoning, my lab uses scientific experimentation to understand patterns and discover knowledge. I have broad research experience in Artificial Intelligence with specific expertise in natural language processing, computer vision, data science, and pattern recognition.'),
    (16, 'guobin.xu@morgan.edu',          'Dr.', 'Guobin',     'Xu',           5, 20, 'administrator', ''),  -- Director of MS Advanced Computing
    -- Lecturers
    (17, 'grace.steele@morgan.edu',       'Ms.', 'Grace',      'Steele',       5, 20, 'professor', ''),      -- Lecturer
    (18, 'sam.tannouri@morgan.edu',       'Dr.', 'Sam',        'Tannouri',     5, 20, 'professor', ''),      -- Lecturer
    -- Staff
    (19, 'wendy.smith@morgan.edu',        'Ms.', 'Wendy',      'Smith',        5, 20, 'staff', '');

INSERT INTO faculty (id, email, prefix, first_name, last_name, college_id, department_id, role) VALUES
    -- Mathematics
    (20, 'asamoah.nkwanta@morgan.edu',    'Dr.', 'Asamoah',    'Nkwanta',      5, 21, 'chair'),
    (21, 'xuming.xie@morgan.edu',         'Dr.', 'Xuming',     'Xie',          5, 21, 'administrator'),  -- Graduate Program Coordinator
    (22, 'candice.marshall@morgan.edu',   'Dr.', 'Candice',    'Marshall',     5, 21, 'administrator'),  -- Director of Actuarial Science
    (23, 'michelle.rockward@morgan.edu',  'Mrs.','Michelle',   'Rockward',     5, 21, 'staff'),          -- Lecturer / Asst. to the Chair
    (24, 'gaston.nguerekata@morgan.edu',  'Dr.', 'Gaston',     'Nguerekata',   5, 21, 'professor'),
    (25, 'mingchao.cai@morgan.edu',       'Dr.', 'Mingchao',   'Cai',          5, 21, 'professor'),
    (26, 'jonathan.farley@morgan.edu',    'Dr.', 'Jonathan',   'Farley',       5, 21, 'professor'),
    (27, 'charly.woodruff-white@morgan.edu','Ms.','Charly',    'Woodruff-White',5,21, 'professor'),      -- Web Editor; Lecturer
    (28, 'avreis.wallace@morgan.edu',     'Ms.', 'Avreis',     'Wallace',      5, 21, 'staff'),          -- Administrative Assistant
    -- English
    (29, 'dolan.hubbard@morgan.edu',   'Dr.', 'Dolan',      'Hubbard',    1, 2,  'chair'),
    (30, 'ruthe.sheffey@morgan.edu',   'Dr.', 'Ruthe',      'Sheffey',    1, 2,  'professor'),
    -- Biology
    (31, 'cleo.hughes@morgan.edu',     'Dr.', 'Cleo',       'Hughes',     5, 18, 'chair'),
    (32, 'evans.afriyie@morgan.edu',   'Dr.', 'Evans',      'Afriyie',    5, 18, 'professor'),
    (33, 'cierra.jackson@morgan.edu',     'Ms.', 'Cierra',     'Jackson',      5, 18, 'staff'),
    -- Chemistry
    (34, 'santosh.mandal@morgan.edu',  'Dr.', 'Santosh',    'Mandal',     5, 19, 'chair'),
    -- Physics
    (35, 'willie.rockward@morgan.edu', 'Dr.', 'Willie',     'Rockward',   5, 22, 'chair'),
    -- Information Science and Systems
    (36, 'roy.brown@morgan.edu',       'Dr.', 'Roy',        'Brown',      3, 15, 'chair'),
    (37, 'angela.davis@morgan.edu',    'Dr.', 'Angela',     'Davis',      3, 15, 'professor'),
    -- Electrical and Computer Engineering
    (38, 'craig.scott@morgan.edu',     'Dr.', 'Craig',      'Scott',      7, 27, 'chair'),
    -- Civil Engineering
    (39, 'oludare.owolabi@morgan.edu', 'Dr.', 'Oludare',    'Owolabi',    7, 26, 'chair'),
    -- Business Administration
    (40, 'fikru.b@morgan.edu',         'Dr.', 'Fikru',      'Boghossian', 3, 14, 'chair'),
    (41, 'tyrone.holmes@morgan.edu',   'Dr.', 'Tyrone',     'Holmes',     3, 14, 'professor'),
    -- Accounting
    (42, 'glenda.glover@morgan.edu',   'Dr.', 'Glenda',     'Glover',     3, 13, 'professor'),
    -- Economics
    (43, 'omari.swinton@morgan.edu',   'Dr.', 'Omari',      'Swinton',    1, 1,  'chair'),
    -- Psychology
    (44, 'alfonso.cmpb@morgan.edu',    'Dr.', 'Alfonso',    'Campbell',   1, 7,  'chair'),
    -- History
    (45, 'ida.jones@morgan.edu',       'Dr.', 'Ida',        'Jones',      1, 4,  'chair'),
    -- Deans
    (46, 'kevin.banks@morgan.edu',     'Dr.', 'Kevin',      'Banks',      5, 20, 'dean'),
    (47, 'oscar.barton@morgan.edu',    'Dr.', 'Oscar',      'Barton',     7, 27, 'dean');

-- ---------------------------------------------------------------------------
-- STUDENTS
-- password_hash is a placeholder 32-byte value for development only.
-- discipline corresponds to the student's declared major.
-- ---------------------------------------------------------------------------
INSERT INTO students (id, email, first_name, last_name, password_hash, discipline, begin_term) VALUES
    (1,  'jharris1@morgan.edu',   'Jada',    'Harris',   X'0000000000000000000000000000000000000000000000000000000000000001', 'Computer Science',                1),
    (2,  'mwilliams2@morgan.edu', 'Marcus',  'Williams', X'0000000000000000000000000000000000000000000000000000000000000002', 'Computer Science',                1),
    (3,  'arobinson3@morgan.edu', 'Aaliyah', 'Robinson', X'0000000000000000000000000000000000000000000000000000000000000003', 'Information Science and Systems', 2),
    (4,  'djohnson4@morgan.edu',  'Devon',   'Johnson',  X'0000000000000000000000000000000000000000000000000000000000000004', 'Electrical Engineering',          2),
    (5,  'sthomas5@morgan.edu',   'Simone',  'Thomas',   X'0000000000000000000000000000000000000000000000000000000000000005', 'Biology',                         1),
    (6,  'abrown6@morgan.edu',    'Andre',   'Brown',    X'0000000000000000000000000000000000000000000000000000000000000006', 'Civil Engineering',               4),
    (7,  'kdavis7@morgan.edu',    'Kayla',   'Davis',    X'0000000000000000000000000000000000000000000000000000000000000007', 'Psychology',                      4),
    (8,  'tjackson8@morgan.edu',  'Tyree',   'Jackson',  X'0000000000000000000000000000000000000000000000000000000000000008', 'Mathematics',                     2),
    (9,  'imitchell9@morgan.edu', 'Imani',   'Mitchell', X'0000000000000000000000000000000000000000000000000000000000000009', 'Business Administration',         1),
    (10, 'jcarter10@morgan.edu',  'Jordan',  'Carter',   X'000000000000000000000000000000000000000000000000000000000000000A', 'Computer Science',                4),
    (11, 'nbailey11@morgan.edu',  'Nia',     'Bailey',   X'000000000000000000000000000000000000000000000000000000000000000B', 'English',                         2),
    (12, 'caustin12@morgan.edu',  'Cameron', 'Austin',   X'000000000000000000000000000000000000000000000000000000000000000C', 'Multimedia Journalism',           4),
    (13, 'tcole13@morgan.edu',    'Taylor',  'Cole',     X'000000000000000000000000000000000000000000000000000000000000000D', 'Nursing',                         1),
    (14, 'mfoster14@morgan.edu',  'Malik',   'Foster',   X'000000000000000000000000000000000000000000000000000000000000000E', 'Computer Science',                2),
    (15, 'agreen15@morgan.edu',   'Asia',    'Green',    X'000000000000000000000000000000000000000000000000000000000000000F', 'Accounting',                      4);

INSERT INTO students (id, email, first_name, last_name, password_hash, discipline, begin_term, created_at) VALUES
    (16, 'kequi4@morgan.edu', 'Kevin', 'Quintero',
     X'0000000000000000000000000000000000000000000000000000000000000010',
     'Computer Science', 1, '2024-08-20 09:00:00');

-- ---------------------------------------------------------------------------
-- SECTIONS  (Fall 2025 = term 4, Spring 2026 = term 5)
-- "capcity" matches the schema's column name as written.
INSERT INTO sections (id, course_id, term_id, instructor_id, section, capacity, enrolled, waitlisted) VALUES
    -- ========================================================
    -- FALL 2024 (term 1) -- legacy rows for prior-term enrollments
    -- ========================================================
    (1,  1,  1, 18, '001', 35, 33, 0),  -- COSC 111 / Tannouri
    (2,  2,  1, 12, '001', 30, 28, 0),  -- COSC 112 / Paudel
    (3,  9,  1, 13, '001', 30, 27, 0),  -- COSC 241 Discrete Structures / Sakk
    (4, 12,  1, 14, '001', 30, 24, 0),  -- COSC 281 / Stojkovic

    -- ========================================================
    -- SPRING 2025 (term 2) -- legacy rows
    -- ========================================================
    (5,  3,  2, 12, '001', 30, 28, 0),  -- COSC 150 / Paudel
    (6,  5,  2,  4, '001', 25, 23, 0),  -- COSC 220 / Ali
    (7, 23,  2,  2, '001', 25, 22, 0),  -- COSC 354 OS / Rahman

    -- ========================================================
    -- FALL 2025 (term 4) -- the principal scheduled term
    -- ========================================================
    -- 100-level: multiple sections to absorb the freshman load
    (10, 1,  4, 18, '001', 35, 33, 2),  -- COSC 111 sec 001 / Tannouri (MWF 9:00)
    (11, 1,  4, 17, '002', 35, 30, 0),  -- COSC 111 sec 002 / Steele   (MWF 11:00)
    (12, 1,  4, 18, 'W01', 30, 28, 0),  -- COSC 111 online             / Tannouri
    (13, 2,  4, 12, '001', 30, 28, 1),  -- COSC 112 sec 001 / Paudel   (MWF 10:00)
    (14, 2,  4,  6, '002', 30, 26, 0),  -- COSC 112 sec 002 / Dacon    (TR 11:00)
    (15, 3,  4, 12, '001', 30, 25, 0),  -- COSC 150            / Paudel

    -- 200-level core
    (16, 4,  4, 17, '001', 30, 24, 0),  -- COSC 201 Data Analysis / Steele
    (17, 5,  4,  4, '001', 25, 25, 3),  -- COSC 220 sec 001 / Ali
    (18, 5,  4,  4, '002', 25, 22, 0),  -- COSC 220 sec 002 / Ali
    (19, 6,  4, 18, '001', 25, 20, 0),  -- COSC 237 Adv Programming / Tannouri
    (20, 7,  4, 14, '001', 25, 23, 0),  -- COSC 238 OOP / Stojkovic
    (21, 8,  4, 18, '001', 25, 18, 0),  -- COSC 239 Java / Tannouri
    (22, 9,  4, 13, '001', 30, 28, 0),  -- COSC 241 Discrete / Sakk
    (23,10,  4, 13, '001', 30, 24, 0),  -- COSC 243 Comp Arch / Sakk
    (24,11,  4,  6, '001', 30, 27, 1),  -- COSC 251 Intro Data Sci / Dacon
    (25,12,  4, 14, '001', 30, 28, 0),  -- COSC 281 Discrete Struct / Stojkovic

    -- 300-level
    (26,13,  4, 13, '001', 25, 22, 0),  -- COSC 320 Algorithms / Sakk
    (27,14,  4,  8, '001', 25, 20, 0),  -- COSC 323 Crypto / Heydari
    (28,15,  4,  9, '001', 25, 18, 0),  -- COSC 332 Game Design / Mack
    (29,16,  4,  9, '001', 25, 22, 0),  -- COSC 338 Mobile / Mack
    (30,17,  4, 16, '001', 20, 14, 0),  -- COSC 345 HPC / Xu
    (31,18,  4,  5, '001', 25, 24, 0),  -- COSC 349 Networks / Dabaghchian
    (32,19,  4,  1, '001', 25, 23, 1),  -- COSC 350 Found Cyber / Wang
    (33,20,  4,  8, '001', 25, 25, 4),  -- COSC 351 Cybersecurity / Heydari
    (34,21,  4, 14, '001', 25, 19, 0),  -- COSC 352 PL / Stojkovic
    (35,23,  4,  2, '001', 25, 23, 0),  -- COSC 354 OS / Rahman
    (36,24,  4, 10, '001', 20, 12, 0),  -- COSC 356 Compilers / Mao
    (37,25,  4,  5, '001', 25, 21, 0),  -- COSC 358 Net Security / Dabaghchian
    (38,26,  4,  3, '001', 25, 24, 0),  -- COSC 359 Database / Chouchane
    (39,27,  4,  7, '001', 20, 15, 0),  -- COSC 383 Numerical / Guo
    (40,28,  4, 13, '001', 20, 16, 0),  -- COSC 385 Theory / Sakk

    -- 400-level
    (41,30,  4, 15, '001', 25, 22, 0),  -- COSC 458 SE / Oladunni
    (42,32,  4,  9, '001', 20, 17, 0),  -- COSC 460 Graphics / Mack
    (43,33,  4, 11, '001', 25, 25, 2),  -- COSC 470 AI / Ojeme
    (44,34,  4,  6, '001', 25, 24, 1),  -- COSC 472 ML / Dacon
    (45,35,  4, 11, '001', 20, 14, 0),  -- COSC 480 Image Proc / Ojeme
    (46,36,  4, 10, '001', 15,  9, 0),  -- COSC 486 Quantum / Mao
    (47,37,  4, 15, '001', 20, 18, 0),  -- COSC 490 Senior Project / Oladunni

    -- ========================================================
    -- SPRING 2026 (term 5)
    -- ========================================================
    (60, 1,  5, 17, '001', 35, 30, 0),  -- COSC 111 / Steele
    (61, 1,  5, 18, 'W01', 30, 24, 0),  -- COSC 111 online / Tannouri
    (62, 2,  5, 12, '001', 30, 27, 0),  -- COSC 112 / Paudel
    (63, 2,  5,  6, '002', 30, 25, 0),  -- COSC 112 / Dacon
    (64, 3,  5,  4, '001', 30, 24, 0),  -- COSC 150 / Ali

    (65, 5,  5,  4, '001', 25, 23, 1),  -- COSC 220 / Ali
    (66, 7,  5, 14, '001', 25, 22, 0),  -- COSC 238 OOP / Stojkovic
    (67, 9,  5, 13, '001', 30, 26, 0),  -- COSC 241 Discrete / Sakk
    (68,10,  5,  2, '001', 30, 24, 0),  -- COSC 243 Comp Arch / Rahman
    (69,11,  5,  6, '001', 30, 28, 0),  -- COSC 251 Data Sci / Dacon
    (70,12,  5, 14, '001', 30, 27, 0),  -- COSC 281 / Stojkovic

    (71,13,  5, 13, '001', 25, 21, 0),  -- COSC 320 Algorithms / Sakk
    (72,14,  5,  8, '001', 25, 19, 0),  -- COSC 323 Crypto / Heydari
    (73,18,  5,  5, '001', 25, 22, 0),  -- COSC 349 Networks / Dabaghchian
    (74,20,  5,  1, '001', 25, 24, 2),  -- COSC 351 Cybersecurity / Wang
    (75,22,  5,  2, '001', 25, 18, 0),  -- COSC 353 Major OS / Rahman
    (76,23,  5,  2, '001', 25, 22, 0),  -- COSC 354 OS / Rahman
    (77,26,  5,  3, '001', 25, 23, 0),  -- COSC 359 Database / Chouchane

    (78,29,  5, 11, '001', 15, 11, 0),  -- COSC 391 Conference / Ojeme
    (79,30,  5, 15, '001', 25, 23, 0),  -- COSC 458 SE / Oladunni
    (80,31,  5,  3, '001', 25, 21, 0),  -- COSC 459 DB Design / Chouchane
    (81,33,  5, 11, '001', 25, 22, 0),  -- COSC 470 AI / Ojeme
    (82,34,  5,  6, '001', 25, 25, 3),  -- COSC 472 ML / Dacon
    (83,38,  5, 15, '001', 20, 17, 0),  -- COSC 491 Senior Project Cont / Oladunni
    (84,39,  5, 11, '001', 12,  6, 0),  -- COSC 498 Conference / Ojeme
    (85,40,  5,  3, '001', 25, 19, 0),  -- COSC 499 Senior Internship / Chouchane
    -- Fall 2024 (term 1) extras
    (100, 49, 1, 20, '001', 30, 28, 0),  -- MATH 241 Calculus I / Nkwanta
    (101, 61, 1, 29, '001', 25, 23, 0),  -- ENGL 101 / Hubbard
    (102,  3, 1, 12, '001', 30, 25, 0),  -- COSC 150 / Paudel  (extra COSC for Fall 2024)
 
    -- Spring 2025 (term 2) extras
    (103, 50, 2, 20, '001', 30, 27, 0),  -- MATH 242 Calculus II / Nkwanta
    (104, 62, 2, 30, '001', 25, 22, 0),  -- ENGL 102 / Sheffey
    (105,  9, 2, 13, '001', 30, 26, 0),  -- COSC 241 Discrete / Sakk
 
    -- Fall 2025 (term 4) extras
    (106, 51, 4, 21, '001', 30, 24, 0),  -- MATH 243 Calculus III / Xie
    (107, 65, 4, 30, '001', 25, 20, 0),  -- ENGL 201 World Lit / Sheffey
 
    -- Spring 2026 (term 5) extras
    (108, 52, 5, 22, '001', 30, 22, 0);  -- MATH 312 Linear Algebra I / Marshall

-- ---------------------------------------------------------------------------
-- SECTION MEETINGS
-- One row per scheduled meeting. Section is connected to its days through
-- the meeting_days table below. Times stored as 24-hour HH:MM TEXT to
-- satisfy the schema CHECK that start_time < end_time string-comparison.
--
-- Real Morgan State campus buildings used:
--   * McMechen Hall    (CS department HQ; rooms 207, 309, 405, 503, 507, 615)
--   * Calloway Hall    (SCMNS overflow lecture rooms; 210, 320)
--   * Dixon Research   (Dixon Center 200 seminar room used for capstones)
--   * "Online -- Canvas" for asynchronous online sections
-- Standard MWF block: 50 minutes; standard TR block: 75 minutes.
-- ---------------------------------------------------------------------------
INSERT INTO section_meetings (id, section_id, start_time, end_time, location) VALUES
    -- ===== Fall 2024 (legacy) =====
    (1,  1, '09:00', '09:50', 'McMechen Hall 207'),
    (2,  2, '10:00', '10:50', 'McMechen Hall 207'),
    (3,  3, '11:00', '12:15', 'McMechen Hall 309'),
    (4,  4, '13:00', '14:15', 'McMechen Hall 309'),

    -- ===== Spring 2025 (legacy) =====
    (5,  5, '10:00', '10:50', 'McMechen Hall 207'),
    (6,  6, '13:00', '14:15', 'McMechen Hall 309'),
    (7,  7, '14:30', '15:45', 'McMechen Hall 405'),

    -- ===== Fall 2025 -- 100-level =====
    (10, 10, '09:00', '09:50', 'McMechen Hall 207'),  -- COSC 111 001 MWF
    (11, 11, '11:00', '11:50', 'McMechen Hall 207'),  -- COSC 111 002 MWF
    (12, 12, '00:01', '23:59', 'Online - Canvas'),    -- COSC 111 W01 async
    (13, 13, '10:00', '10:50', 'McMechen Hall 207'),  -- COSC 112 001 MWF
    (14, 14, '11:00', '12:15', 'McMechen Hall 309'),  -- COSC 112 002 TR
    (15, 15, '13:00', '13:50', 'McMechen Hall 207'),  -- COSC 150 MWF

    -- ===== Fall 2025 -- 200-level =====
    (16, 16, '12:30', '13:45', 'Calloway Hall 320'),  -- COSC 201 TR (moved off McMechen 309)
    (17, 17, '08:00', '08:50', 'McMechen Hall 309'),  -- COSC 220 001 MWF
    (18, 18, '12:00', '12:50', 'McMechen Hall 309'),  -- COSC 220 002 MWF
    (19, 19, '09:30', '10:45', 'McMechen Hall 405'),  -- COSC 237 TR (moved to morning)
    (20, 20, '13:00', '14:15', 'McMechen Hall 405'),  -- COSC 238 TR (moved to 1pm to free Stojkovic 11-12:15 for COSC 281)
    (21, 21, '14:30', '15:45', 'McMechen Hall 405'),  -- COSC 239 TR (moved off 13:00 to make room for 238)
    (22, 22, '09:00', '09:50', 'Calloway Hall 210'),  -- COSC 241 MWF
    (23, 23, '10:00', '10:50', 'Calloway Hall 210'),  -- COSC 243 MWF
    (24, 24, '14:30', '15:45', 'McMechen Hall 309'),  -- COSC 251 TR
    (25, 25, '11:00', '12:15', 'Calloway Hall 320'),  -- COSC 281 TR

    -- ===== Fall 2025 -- 300-level =====
    (26, 26, '11:00', '12:15', 'McMechen Hall 309'),  -- COSC 320 TR (moved to 11am 309)
    (27, 27, '14:30', '15:45', 'McMechen Hall 503'),  -- COSC 323 TR
    (28, 28, '16:00', '17:15', 'McMechen Hall 405'),  -- COSC 332 TR (game lab)
    (29, 29, '09:30', '10:45', 'McMechen Hall 503'),  -- COSC 338 TR (moved to morning to free 503 11am for 470)
    (30, 30, '14:30', '15:45', 'McMechen Hall 615'),  -- COSC 345 TR (HPC lab)
    (31, 31, '13:00', '14:15', 'McMechen Hall 503'),  -- COSC 349 TR
    (32, 32, '11:00', '12:15', 'McMechen Hall 615'),  -- COSC 350 TR (moved out of 503)
    (33, 33, '16:30', '17:45', 'McMechen Hall 503'),  -- COSC 351 TR (cyber lab)
    (34, 34, '09:30', '10:45', 'McMechen Hall 309'),  -- COSC 352 TR
    (35, 35, '13:00', '13:50', 'McMechen Hall 309'),  -- COSC 354 MWF (moved to 1pm)
    (36, 36, '14:30', '15:45', 'Calloway Hall 320'),  -- COSC 356 TR (moved out of McMechen 405)
    (37, 37, '15:00', '16:15', 'McMechen Hall 503'),  -- COSC 358 TR (afternoon, frees Dabaghchian at 13:00)
    (38, 38, '10:00', '10:50', 'McMechen Hall 405'),  -- COSC 359 MWF
    (39, 39, '14:30', '15:45', 'Calloway Hall 320'),  -- COSC 383 TR
    (40, 40, '14:00', '14:50', 'McMechen Hall 309'),  -- COSC 385 MWF

    -- ===== Fall 2025 -- 400-level =====
    (41, 41, '11:00', '12:15', 'McMechen Hall 405'),  -- COSC 458 SE TR (moved to free 14:30)
    (42, 42, '11:00', '12:15', 'McMechen Hall 615'),  -- COSC 460 Graphics TR
    (43, 43, '11:00', '12:15', 'McMechen Hall 503'),  -- COSC 470 AI TR (moved to 503 to avoid 309 collision)
    (44, 44, '13:00', '14:15', 'McMechen Hall 309'),  -- COSC 472 ML TR
    (45, 45, '13:00', '14:15', 'McMechen Hall 615'),  -- COSC 480 Image Proc TR
    (46, 46, '16:00', '18:30', 'McMechen Hall 615'),  -- COSC 486 Quantum (Wed evening)
    (47, 47, '15:00', '17:30', 'Dixon Research 200'), -- COSC 490 capstone (Wed)

    -- ===== Spring 2026 =====
    (60, 60, '10:00', '10:50', 'McMechen Hall 207'),  -- COSC 111 MWF
    (61, 61, '00:01', '23:59', 'Online - Canvas'),    -- COSC 111 W01
    (62, 62, '11:00', '11:50', 'McMechen Hall 207'),  -- COSC 112 MWF
    (63, 63, '09:30', '10:45', 'McMechen Hall 309'),  -- COSC 112 002 TR (Dacon, moved to morning)
    (64, 64, '14:30', '15:20', 'McMechen Hall 207'),  -- COSC 150 MWF

    (65, 65, '09:00', '09:50', 'McMechen Hall 309'),  -- COSC 220 MWF
    (66, 66, '13:00', '14:15', 'McMechen Hall 405'),  -- COSC 238 TR (moved to 1pm for Stojkovic)
    (67, 67, '10:00', '10:50', 'Calloway Hall 210'),  -- COSC 241 MWF
    (68, 68, '09:00', '09:50', 'Calloway Hall 210'),  -- COSC 243 MWF (Rahman, moved off 11 for 354)
    (69, 69, '13:00', '14:15', 'McMechen Hall 309'),  -- COSC 251 TR
    (70, 70, '11:00', '12:15', 'Calloway Hall 320'),  -- COSC 281 TR

    (71, 71, '11:00', '12:15', 'McMechen Hall 615'),  -- COSC 320 TR (moved to clear 405 14:30)
    (72, 72, '11:00', '12:15', 'McMechen Hall 503'),  -- COSC 323 TR
    (73, 73, '13:00', '14:15', 'McMechen Hall 503'),  -- COSC 349 TR
    (74, 74, '15:00', '16:15', 'McMechen Hall 503'),  -- COSC 351 TR
    (75, 75, '14:30', '15:20', 'McMechen Hall 309'),  -- COSC 353 MWF
    (76, 76, '11:00', '11:50', 'McMechen Hall 309'),  -- COSC 354 MWF
    (77, 77, '13:00', '13:50', 'McMechen Hall 405'),  -- COSC 359 MWF

    (78, 78, '17:00', '19:30', 'McMechen Hall 503'),  -- COSC 391 conference (Wed evening)
    (79, 79, '14:30', '15:45', 'McMechen Hall 405'),  -- COSC 458 SE TR
    (80, 80, '16:00', '17:15', 'McMechen Hall 405'),  -- COSC 459 DB TR
    (81, 81, '11:00', '12:15', 'McMechen Hall 309'),  -- COSC 470 AI TR
    (82, 82, '15:00', '16:15', 'McMechen Hall 309'),  -- COSC 472 ML TR (Dacon, moved to free 13:00 for 251)
    (83, 83, '15:00', '17:30', 'Dixon Research 200'), -- COSC 491 (Wed)
    (84, 84, '17:00', '19:30', 'McMechen Hall 503'),  -- COSC 498 conference (Mon evening)
    (85, 85, '00:01', '23:59', 'Off-Campus Internship'), -- COSC 499 internship

    (100, 100, '09:00', '09:50', 'Calloway Hall 210'),   -- MATH 241 MWF
    (101, 101, '10:00', '10:50', 'Holmes Hall 110'),     -- ENGL 101 MWF
    (102, 102, '13:00', '13:50', 'McMechen Hall 405'),   -- COSC 150 MWF
    (103, 103, '09:00', '09:50', 'Calloway Hall 210'),   -- MATH 242 MWF
    (104, 104, '11:00', '11:50', 'Holmes Hall 110'),     -- ENGL 102 MWF
    (105, 105, '14:00', '14:50', 'McMechen Hall 309'),   -- COSC 241 MWF
    (106, 106, '10:00', '10:50', 'Calloway Hall 210'),   -- MATH 243 MWF
    (107, 107, '12:30', '13:45', 'Holmes Hall 215'),     -- ENGL 201 TR
    (108, 108, '11:00', '11:50', 'Calloway Hall 210');   -- MATH 312 MWF


-- ---------------------------------------------------------------------------
-- MEETING DAYS
-- One row per (meeting, weekday). Day codes: 1=Mon ... 7=Sun.
-- For online sections we use day 1 (a notional Monday "check-in") so the
-- (meeting_id, day) primary key still fires; all-week async could also be
-- represented as multiple rows but Morgan's WebSIS records online sections
-- with a single day flag.
-- ---------------------------------------------------------------------------
INSERT INTO meeting_days (meeting_id, day) VALUES
    -- Fall 2024 legacy
    (1, 1), (1, 3), (1, 5),       -- COSC 111 MWF
    (2, 1), (2, 3), (2, 5),       -- COSC 112 MWF
    (3, 2), (3, 4),               -- COSC 241 TR
    (4, 2), (4, 4),               -- COSC 281 TR

    -- Spring 2025 legacy
    (5, 1), (5, 3), (5, 5),       -- COSC 150 MWF
    (6, 2), (6, 4),               -- COSC 220 TR
    (7, 2), (7, 4),               -- COSC 354 TR

    -- Fall 2025 100-level
    (10, 1), (10, 3), (10, 5),    -- COSC 111 001
    (11, 1), (11, 3), (11, 5),    -- COSC 111 002
    (12, 1),                      -- COSC 111 W01 (online check-in Mon)
    (13, 1), (13, 3), (13, 5),    -- COSC 112 001
    (14, 2), (14, 4),             -- COSC 112 002
    (15, 1), (15, 3), (15, 5),    -- COSC 150

    -- Fall 2025 200-level
    (16, 2), (16, 4),             -- COSC 201 (TR)
    (17, 1), (17, 3), (17, 5),    -- COSC 220 001
    (18, 1), (18, 3), (18, 5),    -- COSC 220 002
    (19, 2), (19, 4),             -- COSC 237
    (20, 2), (20, 4),             -- COSC 238
    (21, 2), (21, 4),             -- COSC 239
    (22, 1), (22, 3), (22, 5),    -- COSC 241
    (23, 1), (23, 3), (23, 5),    -- COSC 243
    (24, 2), (24, 4),             -- COSC 251
    (25, 2), (25, 4),             -- COSC 281

    -- Fall 2025 300-level
    (26, 2), (26, 4),             -- COSC 320
    (27, 2), (27, 4),             -- COSC 323
    (28, 2), (28, 4),             -- COSC 332
    (29, 2), (29, 4),             -- COSC 338
    (30, 2), (30, 4),             -- COSC 345
    (31, 2), (31, 4),             -- COSC 349
    (32, 2), (32, 4),             -- COSC 350
    (33, 2), (33, 4),             -- COSC 351
    (34, 2), (34, 4),             -- COSC 352
    (35, 1), (35, 3), (35, 5),    -- COSC 354
    (36, 2), (36, 4),             -- COSC 356
    (37, 2), (37, 4),             -- COSC 358
    (38, 1), (38, 3), (38, 5),    -- COSC 359
    (39, 2), (39, 4),             -- COSC 383
    (40, 1), (40, 3), (40, 5),    -- COSC 385

    -- Fall 2025 400-level
    (41, 2), (41, 4),             -- COSC 458
    (42, 2), (42, 4),             -- COSC 460
    (43, 2), (43, 4),             -- COSC 470
    (44, 2), (44, 4),             -- COSC 472
    (45, 2), (45, 4),             -- COSC 480
    (46, 3),                      -- COSC 486 Wed evening
    (47, 3),                      -- COSC 490 Wed afternoon

    -- Spring 2026
    (60, 1), (60, 3), (60, 5),    -- COSC 111
    (61, 1),                      -- COSC 111 W01
    (62, 1), (62, 3), (62, 5),    -- COSC 112 001
    (63, 2), (63, 4),             -- COSC 112 002
    (64, 1), (64, 3), (64, 5),    -- COSC 150

    (65, 1), (65, 3), (65, 5),    -- COSC 220
    (66, 2), (66, 4),             -- COSC 238
    (67, 1), (67, 3), (67, 5),    -- COSC 241
    (68, 1), (68, 3), (68, 5),    -- COSC 243
    (69, 2), (69, 4),             -- COSC 251
    (70, 2), (70, 4),             -- COSC 281

    (71, 2), (71, 4),             -- COSC 320
    (72, 2), (72, 4),             -- COSC 323
    (73, 2), (73, 4),             -- COSC 349
    (74, 2), (74, 4),             -- COSC 351
    (75, 1), (75, 3), (75, 5),    -- COSC 353
    (76, 1), (76, 3), (76, 5),    -- COSC 354
    (77, 1), (77, 3), (77, 5),    -- COSC 359

    (78, 3),                      -- COSC 391 Wed evening
    (79, 2), (79, 4),             -- COSC 458
    (80, 2), (80, 4),             -- COSC 459
    (81, 2), (81, 4),             -- COSC 470
    (82, 2), (82, 4),             -- COSC 472
    (83, 3),                      -- COSC 491 Wed
    (84, 1),                      -- COSC 498 Mon evening
    (85, 1),                      -- COSC 499 internship Mon check-in

    (100, 1), (100, 3), (100, 5),  -- MATH 241 MWF
    (101, 1), (101, 3), (101, 5),  -- ENGL 101 MWF
    (102, 1), (102, 3), (102, 5),  -- COSC 150 MWF
    (103, 1), (103, 3), (103, 5),  -- MATH 242 MWF
    (104, 1), (104, 3), (104, 5),  -- ENGL 102 MWF
    (105, 1), (105, 3), (105, 5),  -- COSC 241 MWF
    (106, 1), (106, 3), (106, 5),  -- MATH 243 MWF
    (107, 2), (107, 4),            -- ENGL 201 TR
    (108, 1), (108, 3), (108, 5);  -- MATH 312 MWF

-- ---------------------------------------------------------------------------
-- ENROLLMENTS
-- Mix of completed (with grade), enrolled, waitlisted, dropped, withdrawn.
-- Grade scale per schema: 0=F, 1=D, 2=C, 3=B, 4=A.
-- ---------------------------------------------------------------------------
INSERT INTO enrollments (student_id, section_id, status, grade, enrolled_at, completed_at) VALUES
    -- Jada Harris (CS, started Fall 2024)
    (1, 1,  'completed', 4, '2024-08-26 10:00:00', '2024-12-13 17:00:00'),
    (1, 7,  'completed', 3, '2024-08-26 10:00:00', '2024-12-13 17:00:00'),
    (1, 4,  'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (1, 18, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    -- Marcus Williams (CS)
    (2, 1,  'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (2, 10, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (2, 7,  'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    -- Aaliyah Robinson (INSS)
    (3, 15, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (3, 16, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (3, 19, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    -- Devon Johnson (EE)
    (4, 17, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (4, 14, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (4, 8,  'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    -- Simone Thomas (Biology)
    (5, 12, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (5, 13, 'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    (5, 7,  'enrolled',  NULL, '2025-08-25 09:00:00', NULL),
    -- Andre Brown (CE), waitlisted into a popular section
    (6, 1,  'waitlisted', NULL, '2025-08-25 09:00:00', NULL),
    (6, 7,  'enrolled',   NULL, '2025-08-25 09:00:00', NULL),
    -- Kayla Davis (Psych)
    (7, 20, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (7, 11, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (7, 21, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    -- Tyree Jackson (Math)
    (8, 9,  'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (8, 8,  'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    -- Imani Mitchell (Business)
    (9, 18, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (9, 19, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (9, 15, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    -- Jordan Carter (CS senior in capstone Spring 2026)
    (10, 6,  'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (10, 24, 'enrolled', NULL, '2025-11-01 09:00:00', NULL),
    -- Nia Bailey (English)
    (11, 11, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (11, 21, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    -- Cameron Austin (Journalism)
    (12, 10, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (12, 20, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    -- Taylor Cole (Nursing) - has a dropped course
    (13, 12, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (13, 13, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (13, 11, 'dropped',  NULL, '2025-08-25 09:00:00', NULL),
    -- Malik Foster (CS) - has a withdrawn course
    (14, 1,  'completed',  3, '2024-08-26 09:00:00', '2024-12-13 17:00:00'),
    (14, 3,  'enrolled',   NULL, '2025-08-25 09:00:00', NULL),
    (14, 7,  'withdrawn',  NULL, '2024-08-26 09:00:00', NULL),
    -- Asia Green (Accounting)
    (15, 19, 'enrolled', NULL, '2025-08-25 09:00:00', NULL),
    (15, 18, 'enrolled', NULL, '2025-08-25 09:00:00', NULL);

INSERT INTO enrollments (student_id, section_id, status, grade, enrolled_at, completed_at) VALUES
    -- ====== FALL 2024 (term 1) -- 5 enrollments: 3 COSC, 1 MATH, 1 ENGL
    (16,   1, 'completed', 4, '2024-08-26 09:00:00', '2024-12-13 17:00:00'),  -- COSC 111
    (16,   2, 'completed', 3, '2024-08-26 09:00:00', '2024-12-13 17:00:00'),  -- COSC 112
    (16, 102, 'completed', 4, '2024-08-26 09:00:00', '2024-12-13 17:00:00'),  -- COSC 150
    (16, 100, 'completed', 3, '2024-08-26 09:00:00', '2024-12-13 17:00:00'),  -- MATH 241
    (16, 101, 'completed', 3, '2024-08-26 09:00:00', '2024-12-13 17:00:00'),  -- ENGL 101
 
    -- ====== SPRING 2025 (term 2) -- 5 enrollments: 3 COSC, 1 MATH, 1 ENGL
    (16,   6, 'completed', 3, '2025-01-27 09:00:00', '2025-05-16 17:00:00'),  -- COSC 220 / Ali
    (16, 105, 'completed', 4, '2025-01-27 09:00:00', '2025-05-16 17:00:00'),  -- COSC 241 Discrete / Sakk
    (16,   7, 'completed', 2, '2025-01-27 09:00:00', '2025-05-16 17:00:00'),  -- COSC 354 OS / Rahman
    (16, 103, 'completed', 2, '2025-01-27 09:00:00', '2025-05-16 17:00:00'),  -- MATH 242 / Nkwanta
    (16, 104, 'completed', 3, '2025-01-27 09:00:00', '2025-05-16 17:00:00'),  -- ENGL 102 / Sheffey
 
    -- ====== FALL 2025 (term 4) -- 5 enrollments: 3 COSC, 1 MATH, 1 ENGL
    (16,  25, 'completed', 3, '2025-08-25 09:00:00', '2025-12-12 17:00:00'),  -- COSC 281
    (16,  26, 'completed', 4, '2025-08-25 09:00:00', '2025-12-12 17:00:00'),  -- COSC 320
    (16,  31, 'completed', 3, '2025-08-25 09:00:00', '2025-12-12 17:00:00'),  -- COSC 349 Networks
    (16, 106, 'completed', 3, '2025-08-25 09:00:00', '2025-12-12 17:00:00'),  -- MATH 243
    (16, 107, 'completed', 4, '2025-08-25 09:00:00', '2025-12-12 17:00:00'),  -- ENGL 201
 
    -- ====== SPRING 2026 (term 5) -- 5 enrollments: 4 COSC, 1 MATH (currently in progress)
    (16,  74, 'enrolled',  NULL, '2026-01-26 09:00:00', NULL),                -- COSC 351 Cybersecurity
    (16,  77, 'enrolled',  NULL, '2026-01-26 09:00:00', NULL),                -- COSC 359 Database
    (16,  72, 'enrolled',  NULL, '2026-01-26 09:00:00', NULL),                -- COSC 323 Crypto
    (16,  78, 'enrolled',  NULL, '2026-01-26 09:00:00', NULL),                -- COSC 391 Conference
    (16, 108, 'enrolled',  NULL, '2026-01-26 09:00:00', NULL);                -- MATH 312


-- ---------------------------------------------------------------------------
-- APPOINTMENTS  (advising sessions; advisor_id -> faculty.id)
-- ---------------------------------------------------------------------------
INSERT INTO appointments (advisor_id, student_id, date) VALUES
    (4,  1,  '2025-10-15 14:00:00'),
    (4,  2,  '2025-10-15 14:30:00'),
    (4,  10, '2025-11-03 10:00:00'),
    (4,  14, '2025-10-22 11:00:00'),
    (7,  8,  '2025-10-20 13:00:00'),
    (15, 3,  '2025-10-10 15:00:00'),
    (16, 4,  '2025-10-12 09:30:00'),
    (10, 5,  '2025-10-18 14:00:00'),
    (17, 6,  '2025-10-25 10:00:00'),
    (22, 7,  '2025-10-19 13:30:00'),
    (19, 9,  '2025-10-21 11:00:00'),
    (8,  11, '2025-10-23 10:30:00'),
    (20, 15, '2025-11-05 14:00:00');

-- ---------------------------------------------------------------------------
-- CONVERSATIONS  (advising chatbot threads)
-- ---------------------------------------------------------------------------
INSERT INTO conversations (id, student_id, title, created_at) VALUES
    (6,  16, 'Picking my Fall 2024 first-semester schedule', '2024-08-15 14:30:00'),
    (7,  16, 'How do I drop a class without losing aid?',    '2024-10-02 19:10:00'),
    (8,  16, 'Spring 2025 prereq check',                     '2024-11-20 21:00:00'),
    (9,  16, 'Should I declare the cybersecurity track?',    '2025-09-18 16:45:00'),
    (10, 16, 'Spring 2026 capstone elective options',        '2026-04-26 11:20:00'),
    (11, 16, 'Internship search for Summer 2026',            '2026-04-28 18:05:00');

-- ---------------------------------------------------------------------------
-- MESSAGES  (chat logs in conversations)
-- ---------------------------------------------------------------------------
INSERT INTO messages (conversation, prompt, response, tokens_used) VALUES
    (6,
     'I am starting as a CS major in Fall 2024. What classes should I take?',
     'A typical first-semester CS load at Morgan is COSC 111 (Intro to CS), COSC 112 (Computer Science I), MATH 241 (Calculus I), and ENGL 101. That puts you at 13 credits. If you want a full 15, COSC 150 is a good optional add. Want me to check open seats?',
     321),
    (6,
     'Yes please check seats and tell me the meeting times.',
     'COSC 111 section 001 meets MWF 9:00 in McMechen Hall and has open seats. COSC 112 section 001 meets MWF 10:00 (Paudel). MATH 241 section 001 meets MWF 9:00 in Calloway -- that conflicts with COSC 111, so I would put you in MATH 241 section 002 if available, or shift COSC 111 to the 11:00 section. ENGL 101 has multiple slots; the MWF 10:00 one fits cleanly.',
     402),
    (7,
     'I am thinking about dropping COSC 112. Will I lose my financial aid?',
     'You currently have 13 credits. Federal aid generally requires at least 12 credits for full-time status, so dropping COSC 112 (a 3-credit course) would put you at 10 credits and could reduce your aid package. Before dropping, talk to the Financial Aid office and your advisor. You can also consider switching to a different COSC 112 section instead of dropping outright.',
     289),
    (8,
     'For Spring 2025 can I take COSC 220 and COSC 241 at the same time?',
     'Yes. COSC 220 lists COSC 112 as the prereq, which you completed in Fall 2024 with a B. COSC 241 (Discrete Structures) does not have a strict programming prereq and is commonly taken in the second semester. Both are 3 credits each. With MATH 242 and ENGL 102 you would be at 13 credits; adding any 3-credit elective would bring you to 16.',
     358),
    (9,
     'I am interested in the cybersecurity track. What should I take next?',
     'Great choice. The cybersecurity track typically begins with COSC 350 (Foundations of Cybersecurity) followed by COSC 351 (Cybersecurity) and COSC 358 (Network Security). COSC 350 has COSC 220 as a prereq, which you completed. COSC 323 (Cryptography) is also a strong companion. For Spring 2026 I would recommend COSC 351 plus COSC 323 alongside your remaining core requirements.',
     412),
    (9,
     'How do I formally declare the track?',
     'There is no separate declaration in the registrar -- the cybersecurity track is recorded by your CS advisor in your degree plan. Schedule an advising appointment with Ms. Smith and bring a draft of your remaining coursework. She will mark the track in your audit so the cybersecurity electives count toward the concentration.',
     244),
    (10,
     'I have room for one more course in Spring 2026. What should I add?',
     'Looking at your transcript, you have completed COSC 320 and COSC 349 with strong grades. Good Spring 2026 fits would be COSC 359 (Database Design), COSC 391 (Conference Course), or COSC 458 (Software Engineering). Given your cybersecurity interest, COSC 391 this term is running on threat-intel pipelines, which lines up well. Want me to pull the syllabus?',
     376),
    (10,
     'Yes please, and tell me how it stacks against COSC 359.',
     'COSC 391 (Ojeme) this term is project-heavy with one large team-based capstone-style deliverable; the syllabus is on the McMechen Hall bulletin board and Canvas. COSC 359 (Chouchane) is more traditional -- weekly assignments, a midterm, and a final database project. If you already feel comfortable with relational design, COSC 391 will stretch you more; if you want a solid foundational grade, COSC 359 is the safer pick.',
     445),
    (11,
     'I want to find a cybersecurity internship for Summer 2026.',
     'A few good places to start: the Morgan State Career Center has an annual cyber/tech fair in February, and the NSA, CISA, and several DoD contractors run HBCU-targeted summer programs with rolling deadlines through March. Given your COSC 351 and COSC 323 work this term, you are well positioned for a SOC analyst or junior pen-test role. I can help you draft a resume bullet for each course if you want.',
     398),
    (11,
     'Yes draft bullets for COSC 351 and COSC 323.',
     'For COSC 351 (Cybersecurity): "Performed hands-on labs in network hardening, web application security, and intrusion detection; analyzed malware samples and authored an incident-response runbook in a controlled lab environment." For COSC 323 (Cryptography): "Implemented symmetric and public-key cryptographic primitives (AES, RSA, Diffie-Hellman) and digital signature workflows; analyzed real-world protocol weaknesses." Tweak the verbs to match the job description and you are set.',
     467);

COMMIT;

-- =========================================================================
-- End of populate.sql
-- =========================================================================