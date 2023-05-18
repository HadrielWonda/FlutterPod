--
-- Class Article as table article
--

CREATE TABLE "article" (
  "id" serial,
  "title" text NOT NULL,
  "content" text NOT NULL,
  "createdAt" timestamp without time zone NOT NULL
);

ALTER TABLE ONLY "article"
  ADD CONSTRAINT article_pkey PRIMARY KEY (id);


