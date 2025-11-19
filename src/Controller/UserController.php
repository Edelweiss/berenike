<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\Routing\Annotation\Route;
use App\Form\UserEditProfileType;
use App\Form\UserChangePasswordType;
use App\Form\UserType;
use Symfony\Component\Security\Http\Authentication\AuthenticationUtils;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Doctrine\ORM\EntityManagerInterface;
use App\Entity\User;
use App\Repository\UserRepository;
use Psr\Log\LoggerInterface;

class UserController extends BerenikeController
{
    private $entityManager;
    private $userRepository;
    private $passwordHasher;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        UserRepository $userRepository,
        UserPasswordHasherInterface $passwordHasher
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->userRepository = $userRepository;
        $this->passwordHasher = $passwordHasher;
    }

    public function editProfile(Request $request, AuthenticationUtils $authenticationUtils, UserPasswordEncoderInterface $passwordEncoder): Response
    {
        //if ($this->getUser()) {
        //     return $this->redirectToRoute('target_path');
        //}

        $user = $this->getUser();
        $form = $this->createForm(UserEditProfileType::class, $user);

        //$form->handleRequest($request);
        if($formData = $this->getParameter('user_edit_profile')){
            $pwd = $formData['password'];
            $checkPass = $passwordEncoder->isPasswordValid($user, $pwd);
            if($checkPass === true) {
                $formDummy = $this->createForm(UserEditProfileType::class, new User());
                $formDummy->handleRequest($request);
                if ($formDummy->isSubmitted() && $formDummy->isValid()) {
                    // Save
                    $user->setUsername($formData['username']);
                    $user->setEmail($formData['email']);
                    $em = $this->getDoctrine()->getManager();
                    $em->persist($user);
                    $em->flush();
                    $this->addFlash('notice', 'Perfect');
                    $form = $this->createForm(UserEditProfileType::class, $user); // cl: Why do I need to create the form anew to make it reflect the persisted changes of its user object in the template?! Whithout this line, it will reflect the user object’s status before the update.
                } else {
                    $this->addFlash('error', 'Invalid form');
                }
            } else {
                $this->addFlash('error', 'Wrong password');
            }
        }

        /*if ($form->isSubmitted() && $form->isValid()) {
            // Save
            $em = $this->getDoctrine()->getManager();
            $em->persist($user);
            $em->flush();
        }*/

        return $this->render('user/editProfile.html.twig', ['form' => $form->createView()]);
    }

    public function changePassword(Request $request, AuthenticationUtils $authenticationUtils, UserPasswordEncoderInterface $passwordEncoder): Response
    {
        $user = $this->getUser();
        $form = $this->createForm(UserChangePasswordType::class, $user);

        if($this->getParameter('user_change_password')){
            if($this->getParameter('password') && $passwordEncoder->isPasswordValid($user, $this->getParameter('password')) === true){
                $form->handleRequest($request);
                if ($form->isSubmitted() && $form->isValid()) {
                    // Save
                    $formData = $this->getParameter('user_change_password');
                    $user->setPassword($passwordEncoder->encodePassword($user, $formData['password']['first']));
                    $em = $this->getDoctrine()->getManager();
                    $em->persist($user);
                    $em->flush();
                    $this->addFlash('notice', 'Perfect');
                } else {
                    $this->addFlash('error', 'Invalid form');
                }
            } else {
                $this->addFlash('error', 'Wrong password');
            }
        }

        return $this->render('user/changePassword.html.twig', ['form' => $form->createView()]);
    }

    public function list(): Response {
        $this->denyAccessUnlessGranted('ROLE_ADMIN', null, 'User management requires administrator privileges.');
        
        if ($this->request->getMethod() == 'POST') {

            // PARAMETERS
            $limit         = $this->getParameter('rows');
            $page          = $this->getParameter('page');
            $offset        = $page * $limit - $limit;
            $offset        = $offset < 0 ? 0 : $offset;
            $sort          = $this->getParameter('sidx');
            $sortDirection = $this->getParameter('sord');

            // ORDER BY
            $orderBy = '';
            if(in_array($sort, ['username', 'email', 'name', 'lastLogin', 'isActive'])){
                $orderBy = ' ORDER BY u.' . $sort . ' ' . $sortDirection;
            }

            // WHERE
            $where = '';
            $parameters = [];
            if($this->getParameter('_search') == 'true'){
                $prefix = ' WHERE ';

                foreach(['username', 'email', 'name'] as $field){
                    if(strlen($this->getParameter($field))){
                        $where .= $prefix . 'u.' . $field . ' LIKE :' . $field;
                        $parameters[$field] = '%' . $this->getParameter($field) . '%';
                        $prefix = ' AND ';
                    }
                }
                
                if($this->getParameter('isActive') !== null && $this->getParameter('isActive') !== ''){
                    $where .= $prefix . 'u.isActive = :isActive';
                    $parameters['isActive'] = $this->getParameter('isActive') === 'true' || $this->getParameter('isActive') === '1';
                    $prefix = ' AND ';
                }
            }

            // COUNT
            $query = $this->entityManager->createQuery('SELECT count(u.id) FROM App\Entity\User u' . $where);
            $query->setParameters($parameters);
            $count = $query->getSingleScalarResult();
            $totalPages = ($count > 0 && $limit > 0) ? ceil($count/$limit) : 0;

            // QUERY
            $query = $this->entityManager->createQuery('SELECT u FROM App\Entity\User u ' . $where . ' ' . $orderBy)
                ->setFirstResult($offset)
                ->setMaxResults($limit);
            $query->setParameters($parameters);
            
            $users = $query->getResult();

            return $this->render('user/list.xml.twig', [
                'users' => $users, 
                'count' => $count, 
                'totalPages' => $totalPages, 
                'page' => $page
            ]);
        } else {
            return $this->render('user/list.html.twig');
        }
    }

    public function show($id): Response {
        $this->denyAccessUnlessGranted('ROLE_ADMIN', null, 'User management requires administrator privileges.');
        
        if(!$id){
            return $this->redirectToRoute('PapyrillioBerenike_UserList');
        }

        $user = $this->userRepository->find($id);
        
        if (!$user) {
            throw $this->createNotFoundException('User not found');
        }

        return $this->render('user/show.html.twig', ['user' => $user]);
    }

    public function new(): Response {
        $this->denyAccessUnlessGranted('ROLE_ADMIN', null, 'User management requires administrator privileges.');
        
        $user = new User();
        $user->setRoles(['ROLE_USER']);
        $user->setIsActive(true);

        $form = $this->createForm(UserType::class, $user);

        if ($this->request->getMethod() == 'POST') {
            $form->handleRequest($this->request);

            if ($form->isValid()) {
                // Get password from form and hash it
                $plainPassword = $form->get('password')->getData();
                if ($plainPassword) {
                    $hashedPassword = $this->passwordHasher->hashPassword($user, $plainPassword);
                    $user->setPassword($hashedPassword);
                }

                $this->entityManager->persist($user);
                $this->entityManager->flush();

                $this->addFlash('notice', 'User "' . $user->getName() . '" (' . $user->getUsername() . ') was created successfully!');
                return $this->redirectToRoute('PapyrillioBerenike_UserShow', ['id' => $user->getId()]);
            }
        }

        return $this->render('user/new.html.twig', ['form' => $form->createView()]);
    }
  
    public function edit($id): Response {
        $this->denyAccessUnlessGranted('ROLE_ADMIN', null, 'User management requires administrator privileges.');
        
        $user = $this->userRepository->find($id);

        if (!$user) {
            throw $this->createNotFoundException('User not found');
        }

        $form = $this->createForm(UserType::class, $user);

        if ($this->request->getMethod() == 'POST') {
            $form->handleRequest($this->request);
            if ($form->isValid()) {
                // Only hash password if a new one was provided
                $plainPassword = $form->get('password')->getData();
                if ($plainPassword) {
                    $hashedPassword = $this->passwordHasher->hashPassword($user, $plainPassword);
                    $user->setPassword($hashedPassword);
                }
                
                $this->entityManager->flush();

                $this->addFlash('notice', 'User "' . $user->getName() . '" was updated successfully!');
                return $this->redirectToRoute('PapyrillioBerenike_UserShow', ['id' => $user->getId()]);
            }
        }

        return $this->render('user/edit.html.twig', [
            'form' => $form->createView(),
            'user' => $user
        ]);
    }

    public function delete($id): Response {
        $this->denyAccessUnlessGranted('ROLE_ADMIN', null, 'User management requires administrator privileges.');
        
        $user = $this->userRepository->find($id);

        if (!$user) {
            throw $this->createNotFoundException('User not found');
        }

        $this->entityManager->remove($user);
        $this->entityManager->flush();

        $this->addFlash('notice', 'User "' . $user->getName() . '" (' . $user->getUsername() . ') was deleted successfully!');
        return $this->redirectToRoute('PapyrillioBerenike_UserList');
    }

}
