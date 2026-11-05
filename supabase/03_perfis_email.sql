-- Guarda o e-mail no perfil, para o administrador ver quem é quem na tela Usuários.
alter table public.perfis add column if not exists email text;

update public.perfis p set email = u.email from auth.users u where u.id = p.id;

create or replace function public.novo_usuario() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.perfis(id, nome, email)
  values (new.id, coalesce(new.raw_user_meta_data->>'nome', new.email), new.email);
  return new;
end $$;

select nome, email, papel, ativo from public.perfis order by papel;
